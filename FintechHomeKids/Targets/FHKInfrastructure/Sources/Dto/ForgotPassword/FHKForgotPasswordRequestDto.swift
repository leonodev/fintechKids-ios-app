//
//  FHKForgotPasswordRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/11/2026.
//

public struct FHKForgotPasswordRequestDto: Encodable, Sendable {
    public let emailParent: String
    
    enum CodingKeys: String, CodingKey {
        case emailParent = "email_parent"
    }
    
    public init(emailParent: String) {
        self.emailParent = emailParent
    }
}
