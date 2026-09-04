//
//  FHKRegisterEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

public struct FHKRegisterEntity: Encodable {
    public let email: String
    public let password: String
    public let familyName: String
    public let approvePIN: String

    public init(email: String,
                password: String,
                familyName: String,
                approvePIN: String
    ) {
        self.email = email
        self.password = password
        self.familyName = familyName
        self.approvePIN = approvePIN
    }
}
