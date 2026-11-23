//
//  FHKResetPasswordResponseEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 22/11/2026.
//

import Foundation

public struct FHKResetPasswordResponseEntity: Sendable, Equatable {
    public let message: String
    public let email: String
    public let updatedAt: String

    public init(
        message: String,
        email: String,
        updatedAt: String
    ) {
        self.message = message
        self.email = email
        self.updatedAt = updatedAt
    }
}
