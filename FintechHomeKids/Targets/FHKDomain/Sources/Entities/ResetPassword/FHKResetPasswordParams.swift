//
//  FHKResetPasswordParams.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 22/11/2026.
//

public struct FHKResetPasswordParams: Sendable, Equatable {
    public let email: String
    public let recoveryCode: String
    public let newPassword: String
    
    public init(email: String, recoveryCode: String, newPassword: String) {
        self.email = email
        self.recoveryCode = recoveryCode
        self.newPassword = newPassword
    }
}
