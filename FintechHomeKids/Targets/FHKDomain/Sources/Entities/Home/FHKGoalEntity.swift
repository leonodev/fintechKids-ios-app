//
//  FHKGoalEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKCore

public struct FHKGoalEntity: DomainModelProtocol {
    public let id: Int?
    public let expirationDate: String
    public let name: String
    public let emailParent: String
    public let value: Int
    public let measureType: String
    public let status: OperationStatus
    
    public init(id: Int? = nil,
                expirationDate: String,
                name: String,
                emailParent: String,
                value: Int,
                measureType: String,
                status: OperationStatus
    ) {
        self.id = id
        self.expirationDate = expirationDate
        self.name = name
        self.emailParent = emailParent
        self.value = value
        self.measureType = measureType
        self.status = status
    }
}

import Foundation

public enum OperationStatus: String, CaseIterable, Sendable {
    case inCurse = "inCurse"
    case completed = "completed"
    case defeated = "defeated"
    case abandoned = "abandoned"
    
    public var value: String {
        return self.rawValue
    }
}
