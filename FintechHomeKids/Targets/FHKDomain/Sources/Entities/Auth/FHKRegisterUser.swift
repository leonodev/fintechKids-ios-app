//
//  FHKRegisterUser.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

public struct FHKRegisterUser: Encodable {
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
