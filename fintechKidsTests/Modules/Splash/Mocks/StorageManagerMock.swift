//
//  StorageManagerMock.swift
//  fintechKids
//
//  Created by Fredy Leon on 5/3/26.
//

import Foundation
import FHKDomain

/// Mock de almacenamiento que ignora las comprobaciones de Sendable de Swift 6.
public final class StorageManagerMock: @unchecked Sendable, FHKStorageManagerProtocol {
    // MARK: - Tracking Properties (UserDefaults)
    public var isCalledSaveUserDefaults = false
    public var isCalledReadUserDefaults = false
    public var isCalledUpdateUserDefaults = false
    public var isCalledDeleteUserDefaults = false
    public var isCalledExists = false
    public var isClearKeychainIfNewInstallation = false
    
    // MARK: - Tracking Properties (Keychain)
    public var isCalledSaveKeychain = false
    public var isCalledReadKeychain = false
    public var isCalledDeleteKeychain = false
    public var isCalledContainsKeychain = false
    public var isCalledClearAllKeychain = false
    public var isCalledIsBiometryAvailable = false

    // MARK: - Mock Data Storage
    public var mockStoredValue: Any?
    public var mockKeychainValue: Any?
    public var mockExistsResponse = false
    public var mockBiometryAvailable = true
    public var mockError: Error?

    public init() {}

    // MARK: - UserDefaults Methods
    public func saveUserDefaults<T: Encodable & Sendable>(_ value: T, forKey key: String) async throws {
        if let error = mockError { throw error }
        isCalledSaveUserDefaults = true
        mockStoredValue = value
    }

    public func readUserDefaults<T: Decodable & Sendable>(_ type: T.Type, forKey key: String) async throws -> T? {
        isCalledReadUserDefaults = true
        return mockStoredValue as? T
    }

    public func updateUserDefaults<T>(_ type: T.Type, forKey key: String, update: @Sendable (T?) -> T?) async throws where T: Decodable, T: Encodable, T: Sendable {
        isCalledUpdateUserDefaults = true
        let currentValue = mockStoredValue as? T
        mockStoredValue = update(currentValue)
    }

    public func deleteUserDefaults(forKey key: String) async throws {
        isCalledDeleteUserDefaults = true
        mockStoredValue = nil
    }

    public func exists(key: String) -> Bool {
        isCalledExists = true
        return mockExistsResponse
    }

    // MARK: - Keychain Methods
    public func saveKeychain<T: Codable & Sendable>(_ value: T, for key: String, requireBiometry: Bool) throws {
        if let error = mockError { throw error }
        isCalledSaveKeychain = true
        mockKeychainValue = value
    }

    public func readKeychain<T: Decodable & Sendable>(_ type: T.Type, for key: String, prompt: String?) throws -> T? {
        if let error = mockError { throw error }
        isCalledReadKeychain = true
        return mockKeychainValue as? T
    }

    public func deleteKeychain(_ key: String) throws {
        if let error = mockError { throw error }
        isCalledDeleteKeychain = true
        mockKeychainValue = nil
    }

    public func containsKeychain(_ key: String) -> Bool {
        isCalledContainsKeychain = true
        return mockKeychainValue != nil
    }

    public func clearAllKeychain() throws {
        if let error = mockError { throw error }
        isCalledClearAllKeychain = true
        mockKeychainValue = nil
    }

    public func isBiometryAvailable() -> Bool {
        isCalledIsBiometryAvailable = true
        return mockBiometryAvailable
    }
    
    public func clearKeychainIfNewInstallation() async {
        isClearKeychainIfNewInstallation = true
    }
}
