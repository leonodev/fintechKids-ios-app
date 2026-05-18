//
//  SplashRepositoryMock.swift
//  fintechKids
//
//  Created by Fredy Leon on 5/3/26.
//

import Foundation
import FHKDomain

public final class SplashRepositoryMock: @unchecked Sendable, FHKSplashRepositoryProtocol {
    
    // MARK: - Tracking Properties
    public var isCalledReadLanguageCurrent = false
    public var readLanguageCurrentCallCount = 0
    
    // MARK: - Mock Data
    public var mockLanguageResponse: String? = nil
    public var mockError: (any FHKError)? = nil

    public init() {}

    // MARK: - Protocol Methods
    public func readLanguageCurrent() async throws -> String? {
        isCalledReadLanguageCurrent = true
        readLanguageCurrentCallCount += 1
        
        // Si configuramos un error en el test, lo lanzamos
        if let error = mockError {
            throw error
        }
        
        return mockLanguageResponse
    }
}
