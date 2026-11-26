//
//  FHKForgotPasswordParams.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

public struct FHKForgotPasswordParams: Sendable, Equatable {
    public let emailParent: String
    
    public init(emailParent: String) {
        self.emailParent = emailParent
    }
}
