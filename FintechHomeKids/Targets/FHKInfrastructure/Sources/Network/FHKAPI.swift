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
                print("Error to encode request body: \(error)")
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
            // Conserva las cabeceras por defecto y sobrescribe/agrega las nuevas
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
    
    // MARK: - Default Headers (Content-Type, Accept & Token opcional)
    public static func defaultHeaders(bearerToken: String? = nil) -> [String: String] {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let token = inject.fhkConfiguration.accessToken(), !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
            
        return headers
    }
    
    // MARK: - Execute (Swift 6 Async/Await + Typed Throws + Retry)
    public func execute<T: Decodable & Sendable>(retries: Int = 1) async throws(FHKAppError) -> T {
        guard let url = self.path,
              let serverUrl = URL(string: "\(getBaseURLAPI())\(url.rawValue)") else {
            throw FHKAppError(.urlInvalid)
        }
        
        let session = URLSession(configuration: makeSessionConfiguration())
        let requestURL: URLRequest = getRequest(serverURL: serverUrl)
        Logger.request(requestURL)
        
        var currentAttempt = 0
        var lastError: FHKAppError = FHKAppError(.invalidResponse)
        
        while currentAttempt <= retries {
            do {
                let (data, response) = try await session.data(for: requestURL)
                
                Logger.response(response, data: data)
                
                guard let responseStatus = response as? HTTPURLResponse else {
                    throw FHKAppError(.unknown)
                }
                
                guard 200...299 ~= responseStatus.statusCode else {
                    throw FHKAppError(.apiError(statusCode: responseStatus.statusCode), responseData: data)
                }
                
                guard !data.isEmpty else {
                    throw FHKAppError(.dataEmpty)
                }
                
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
                
            } catch let appError as FHKAppError {
                lastError = appError
                // Si es un error de negocio HTTP (400, 401, 403, 404, 422), no reintentamos
                if currentAttempt >= retries {
                    throw appError
                }
            } catch {
                let processed = processError(error: error) ?? FHKAppError(.invalidResponse)
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
    private func makeSessionConfiguration() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.multipathServiceType = .interactive
        config.waitsForConnectivity = false
        return config
    }
    
    private func processError(error: Error) -> FHKAppError? {
        if let appError = error as? FHKAppError {
            return appError
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut:
                return FHKAppError(.timeout)
            case .notConnectedToInternet, .networkConnectionLost:
                return FHKAppError(.notConnectedInternet)
            case .badURL:
                return FHKAppError(.urlInvalid)
            case .cannotFindHost, .cannotConnectToHost:
                return FHKAppError(.cannotFindHost)
            case .badServerResponse:
                return FHKAppError(.badServerResponse)
            default:
                return FHKAppError(.unknown)
            }
        }
        
        if error is DecodingError {
            return FHKAppError(.decodingError)
        }
        
        if error is EncodingError {
            return FHKAppError(.encodingError)
        }
        
        return nil
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
