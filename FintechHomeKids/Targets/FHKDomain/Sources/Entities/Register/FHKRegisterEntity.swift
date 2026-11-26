//
//  FHKRegisterEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/11/2026.
//

import Foundation

public struct FHKRegisterEntity: Sendable, Equatable {
    public let id: Int
    public let createdAt: String
    public let nameFamily: String
    public let emailParent: String
    public let approvePin: String
    public let isActive: Bool
    public let updatedAt: String

    public init(
        id: Int,
        createdAt: String,
        nameFamily: String,
        emailParent: String,
        approvePin: String,
        isActive: Bool,
        updatedAt: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.nameFamily = nameFamily
        self.emailParent = emailParent
        self.approvePin = approvePin
        self.isActive = isActive
        self.updatedAt = updatedAt
    }
}


