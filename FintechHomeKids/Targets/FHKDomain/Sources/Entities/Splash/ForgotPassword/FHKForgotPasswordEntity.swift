//
//  FHKForgotPasswordEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import Foundation

public struct FHKForgotPasswordEntity: Sendable, Equatable {
    public let message: String
    public let email: String
    public let expiresInMinutes: Int
    public let debugRecoveryCode: String?

    public init(
        message: String,
        email: String,
        expiresInMinutes: Int,
        debugRecoveryCode: String?
    ) {
        self.message = message
        self.email = email
        self.expiresInMinutes = expiresInMinutes
        self.debugRecoveryCode = debugRecoveryCode
    }
}
