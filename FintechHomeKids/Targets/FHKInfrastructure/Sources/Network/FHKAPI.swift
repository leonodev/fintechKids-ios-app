//
//  FHKAPI.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/11/2026.
//

import Foundation
import FHKCore
import FLibUtils

public enum Method: String, Sendable {
    case GET, POST, PUT, PATCH, DELETE
}

/// DTO privado para decodificar respuestas controladas de FHKBackend: {"error_code": "...", "detail": "..."}
private struct FastAPIControlledErrorDto: Decodable, Sendable {
    let errorCode: FHKBackendErrorCode?
    let detail: String?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case detail
    }
}

public struct FHKAPI: Sendable {
    public let environmentType: FHKEnvironmentType
    public let path: FHKPath?
    public let timeout: Double
    public let body: Data?
    public let method: Method
    public let headerParams: [String: String]
    public let urlParams: [String: String]
    
    // MARK: - Builder (Struct)
    public struct Builder: Sendable {
        private var environmentType: FHKEnvironmentType = .current
        private var path: FHKPath? = nil
        private var timeout: Double = 30
        private var body: Data? = nil
        private var method: Method = .GET
        private var headerParams: [String: String] = FHKAPI.defaultHeaders()
        private var urlParams: [String: String] = [:]
        
        public var fhkConfiguration: FHKConfiguration {
            inject.fhkConfiguration
        }
        
        public init() {}
        
        public func setEnvironmentType(_ environmentType: FHKEnvironmentType) -> Builder {
            var copy = self
            copy.environmentType = environmentType
            return copy
        }
        
        public func setPath(_ path: FHKPath) -> Builder {
            var copy = self
            copy.path = path
            return copy
        }
        
        public func setTimeout(_ timeout: Double) -> Builder {
            var copy = self
            copy.timeout = timeout
            return copy
        }
        
        public func setBody<T: Encodable>(body: T) -> Builder {
            var copy = self
            do {
                let jsonData = try JSONEncoder().encode(body)
                copy.body = jsonData
            } catch {
                Logger.error("Error encoding request body (\(T.self)): \(error)")
            }
            return copy
        }
        
        public func setMethod(_ method: Method) -> Builder {
            var copy = self
            copy.method = method
            return copy
        }
        
        /// Inyecta el JWT Access Token en la cabecera `Authorization: Bearer <token>`
        public func setBearerToken(_ token: String?) -> Builder {
            var copy = self
            if let token = token, !token.isEmpty {
                copy.headerParams["Authorization"] = "Bearer \(token)"
            }
            return copy
        }
        
        public func setHeaderParams(_ headerParams: [String: String]) -> Builder {
            var copy = self
            copy.headerParams.merge(headerParams) { _, new in new }
            return copy
        }
        
        public func set(headerParam: String, value: String?) -> Builder {
            var copy = self
            if let value = value {
                copy.headerParams[headerParam] = value
            }
            return copy
        }
        
        public func setUrlParams(_ urlParams: [String: String]) -> Builder {
            var copy = self
            copy.urlParams = urlParams
            return copy
        }
        
        public func setUrlParams<T: Encodable>(_ params: T) -> Builder {
            var copy = self
            do {
                let data = try JSONEncoder().encode(params)
                if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    var parsedParams: [String: String] = [:]
                    for (key, value) in jsonDict {
                        if let str = value as? String {
                            parsedParams[key] = str
                        } else if let num = value as? NSNumber {
                            if CFGetTypeID(num) == CFBooleanGetTypeID() {
                                parsedParams[key] = num.boolValue ? "true" : "false"
                            } else {
                                parsedParams[key] = num.stringValue
                            }
                        }
                    }
                    copy.urlParams.merge(parsedParams) { _, new in new }
                }
            } catch {
                Logger.error("Error encoding URL params (\(T.self)): \(error)")
            }
            return copy
        }
        
        public func set(urlParam: String, value: String?) -> Builder {
            var copy = self
            if let value = value {
                copy.urlParams[urlParam] = value
            }
            return copy
        }
        
        public func build() -> FHKAPI {
            return FHKAPI(
                environmentType: environmentType,
                path: path,
                timeout: timeout,
                body: body,
                method: method,
                headerParams: headerParams,
                urlParams: urlParams
            )
        }
    }
    
    // MARK: - Default Headers (Content-Type, Accept & Token automático)
    public static func defaultHeaders(bearerToken: String? = nil) -> [String: String] {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let token = bearerToken ?? inject.fhkConfiguration.accessToken(), !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
            
        return headers
    }
    
    // MARK: - Execute (Swift 6 Async/Await + Typed Throws + Smart Retry)
    public func execute<T: Decodable & Sendable>(retries: Int = 1) async throws(FHKAppError) -> T {
        let baseURL = getBaseURLAPI()
        let pathString = self.path?.rawValue ?? ""
        
        guard let url = self.path,
              let serverUrl = URL(string: "\(baseURL)\(url.rawValue)") else {
            throw FHKAppError.invalidURL("\(baseURL)\(pathString)")
        }
        
        let session = URLSession(configuration: makeSessionConfiguration())
        let requestURL: URLRequest = getRequest(serverURL: serverUrl)
        Logger.request(requestURL)
        
        var currentAttempt = 0
        var lastError: FHKAppError = .unknown
        
        while currentAttempt <= retries {
            do {
                let (data, response) = try await session.data(for: requestURL)
                
                Logger.response(response, data: data)
                
                guard let responseStatus = response as? HTTPURLResponse else {
                    throw FHKAppError.unknown
                }
                
                guard 200...299 ~= responseStatus.statusCode else {
                    throw parseBackendError(statusCode: responseStatus.statusCode, data: data)
                }
                
                guard !data.isEmpty else {
                    throw FHKAppError.emptyResponse
                }
                
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
                
            } catch let appError as FHKAppError {
                // Cortar de inmediato (sin reintentar) errores no recuperables o de negocio 4xx
                if shouldAbortImmediately(appError) {
                    throw appError
                }
                
                lastError = appError
                if currentAttempt >= retries {
                    throw appError
                }
            } catch {
                let processed = processError(error: error, requestURL: serverUrl.absoluteString)
                
                if shouldAbortImmediately(processed) {
                    throw processed
                }
                
                lastError = processed
                if currentAttempt >= retries {
                    throw processed
                }
            }
            
            currentAttempt += 1
        }
        
        throw lastError
    }
    
    // MARK: - Helpers Privados
    private func parseBackendError(statusCode: Int, data: Data) -> FHKAppError {
        if let parsed = try? JSONDecoder().decode(FastAPIControlledErrorDto.self, from: data),
           let code = parsed.errorCode {
            return .backend(code, detail: parsed.detail)
        }
        
        if statusCode == 401 {
            return .unauthorized
        }
        
        let fallbackDetail = String(data: data, encoding: .utf8)
        return .apiError(statusCode: statusCode, detail: fallbackDetail)
    }
    
    private func shouldAbortImmediately(_ error: FHKAppError) -> Bool {
        switch error {
        case .unauthorized, .cancelled, .sslError, .decodingError, .encodingError, .invalidURL:
            return true
        case .apiError(let code, _):
            return (400...499).contains(code)
        case .backend(let code, _):
            // Solo reintentar si el backend respondió 500 INTERNAL_SERVER_ERROR
            return code != .internalServerError
        default:
            return false
        }
    }
    
    private func makeSessionConfiguration() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .interactive
        config.waitsForConnectivity = false
        return config
    }
    
    private func processError(error: Error, requestURL: String) -> FHKAppError {
        if let appError = error as? FHKAppError {
            return appError
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeout
            case .notConnectedToInternet, .networkConnectionLost:
                return .notConnectedInternet
            case .badURL:
                return .invalidURL(requestURL)
            case .cannotFindHost, .cannotConnectToHost, .badServerResponse:
                return .apiError(statusCode: urlError.errorCode, detail: urlError.localizedDescription)
            case .secureConnectionFailed,
                 .serverCertificateHasBadDate,
                 .serverCertificateUntrusted,
                 .serverCertificateHasUnknownRoot,
                 .serverCertificateNotYetValid,
                 .clientCertificateRejected,
                 .clientCertificateRequired:
                return .sslError
            case .cancelled:
                return .cancelled
            default:
                return .unknown
            }
        }
        
        if error is DecodingError {
            return .decodingError
        }
        
        if error is EncodingError {
            return .encodingError
        }
        
        if error is CancellationError {
            return .cancelled
        }
        
        return .unknown
    }
    
    private func getRequest(serverURL: URL) -> URLRequest {
        var request = URLRequest(url: serverURL)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = timeout
        request.httpMethod = method.rawValue
        
        headerParams.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        urlParams.forEach { (key, value) in
            request.url?.appendQueryItem(name: key, value: value)
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func getBaseURLAPI() -> String {
        return environmentType.baseURL
    }
}

// MARK: - Extensión para Query Params en URL
public extension URL {
    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        urlComponents.queryItems = queryItems
        if let updatedURL = urlComponents.url {
            self = updatedURL
        }
    }
}
