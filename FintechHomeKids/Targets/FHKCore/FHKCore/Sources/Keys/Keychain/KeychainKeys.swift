//
//  KeychainKeys.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

public struct KeychainKeys {
    private init() {}
}

public extension KeychainKeys {
    static let userKey = "user_key"
    static let familyNameKey = "family_name"
    static let approvePinKey = "approve_pin"
}

public enum KeychainKey: String, CaseIterable, Sendable {
    case authToken
    case refreshToken
    case userCredentials
    case appSettings
    case biometricData
    case appLanguage
}
