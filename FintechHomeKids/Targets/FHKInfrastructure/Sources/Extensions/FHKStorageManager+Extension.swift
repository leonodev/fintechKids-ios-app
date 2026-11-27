//
//  FHKStorageManager+Extension.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 24/11/2026.
//

import FLibStorage
import FHKCore

public extension FHKStorageManager {
    
    func readDefaults<T: Decodable & Sendable>(
        _ type: T.Type,
        forKey key: String,
        orThrow appError: FHKAppError = .userDefaultsFailed
    ) async throws(FHKAppError) -> T? {
        do {
            return try await readUserDefaults(type, forKey: key)
        } catch {
            throw appError
        }
    }
    
    func saveDefaults<T: Encodable & Sendable>(
        _ value: T,
        forKey key: String,
        orThrow appError: FHKAppError = .userDefaultsFailed
    ) async throws(FHKAppError) {
        do {
            try await saveUserDefaults(value, forKey: key)
        } catch {
            throw appError
        }
    }
    
    func readSecureKeychain<T: Decodable & Sendable>(
        _ type: T.Type,
        for key: String,
        prompt: String? = nil,
        orThrow appError: FHKAppError = .readUserMailKeychainFailed
    ) throws(FHKAppError) -> T? {
        do {
            return try readKeychain(type, for: key, prompt: prompt)
        } catch {
            throw appError
        }
    }
    
    func saveSecureKeychain<T: Codable & Sendable>(
        _ value: T,
        for key: String,
        requireBiometry: Bool = false,
        orThrow appError: FHKAppError = .saveTokensKeychainFailed
    ) throws(FHKAppError) {
        do {
            try saveKeychain(value, for: key, requireBiometry: requireBiometry)
        } catch {
            throw appError
        }
    }
}
