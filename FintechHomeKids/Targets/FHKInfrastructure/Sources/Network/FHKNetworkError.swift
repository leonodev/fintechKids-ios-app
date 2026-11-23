//
//  FHKAppError.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/11/2026.
//

import Foundation
import FHKCore

public struct FHKNetworkError: Error, LocalizedError, Sendable, Equatable {
    
    public enum ErrorType: Sendable, Equatable {
        case urlInvalid
        case timeout
        case notConnectedInternet
        case cannotFindHost
        case badServerResponse
        case invalidResponse
        case dataEmpty
        case decodingError
        case encodingError
        case apiError(statusCode: Int)
        case unauthorized
        case cancelled
        case sslError
        case unknown
    }
    
    public let type: ErrorType
    public let backendDetail: String?
    
    public init(_ type: ErrorType, backendDetail: String? = nil) {
        self.type = type
        self.backendDetail = backendDetail
    }
    
    /// Constructor que además intenta extraer automáticamente el `{"detail": "..."}` de FastAPI
    public init(_ type: ErrorType, responseData: Data?) {
        self.type = type
        if let data = responseData,
           let decoded = try? JSONDecoder().decode(FastAPIErrorResponse.self, from: data) {
            self.backendDetail = decoded.detail
        } else {
            self.backendDetail = nil
        }
    }
    
    /// Código HTTP si se trata de un `.apiError`
    public var statusCode: Int? {
        if case let .apiError(code) = type {
            return code
        }
        return nil
    }
    
    /// Indica si el token JWT venció o es inválido (401)
    public var isUnauthorized: Bool {
        return type == .unauthorized || statusCode == 401
    }
    
    /// Mensaje listo para mostrar en alertas de la UI (`error.localizedDescription`)
    public var errorDescription: String? {
        // Si el backend de FastAPI envió un `detail` específico, le damos prioridad
        if let backendDetail, !backendDetail.isEmpty {
            return backendDetail
        }
        
        switch type {
        case .urlInvalid:
            return "The request URL is invalid."
        case .timeout:
            return "The request timed out. Please try again."
        case .notConnectedInternet:
            return "No internet connection available. Please check your network."
        case .cannotFindHost:
            return "Unable to reach the server."
        case .badServerResponse:
            return "Received an invalid response from the server."
        case .invalidResponse:
            return "Unexpected server response."
        case .dataEmpty:
            return "The server returned an empty response."
        case .decodingError:
            return "Failed to process the server response data."
        case .encodingError:
            return "Failed to encode the request parameters."
        case .unauthorized:
            return "Your session has expired. Please log in again."
        case .apiError(let statusCode):
            switch statusCode {
            case 400:
                return "Invalid request (400)."
            case 401:
                return "Unauthorized or expired session (401)."
            case 403:
                return "You do not have permission to perform this action (403)."
            case 404:
                return "The requested resource was not found (404)."
            case 422:
                return "Validation error in the sent fields (422)."
            case 500...599:
                return "Internal server error (\(statusCode)). Please try again later."
            default:
                return "Server error (HTTP \(statusCode))."
            }
        case .cancelled:
            return "Operation Canceled."
        case .sslError:
            return "A secure SSL connection could not be established with the server."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
}

public extension FHKNetworkError {
    func toAppError() -> FHKAppError {
        switch self.type {
        case .notConnectedInternet:
            return .notConnectedInternet
        case .timeout:
            return .timeout
        case .unauthorized:
            return .unauthorized
        case .sslError:
            return .sslError
        default:
            return .apiError(statusCode: self.statusCode ?? 0, detail: self.backendDetail)
        }
    }
}

/// Estructura auxiliar para decodificar el `{"detail": "..."}` que devuelve FastAPI (FHKBackend)
private struct FastAPIErrorResponse: Decodable, Sendable {
    let detail: String
}
