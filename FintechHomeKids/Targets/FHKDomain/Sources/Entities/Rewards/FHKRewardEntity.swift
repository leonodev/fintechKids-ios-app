//
//  FHKRewardEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FHKCore

public struct FHKRewardEntity: DomainModelProtocol {
    public let id: Int?
    public let createdAt: String
    public let name: String
    public let timeRequiered: String
    public let coinsRequiered: Int
    public let emailParent: String
    
    public init(
        id: Int? = nil,
        createdAt: String,
        name: String,
        timeRequiered: String,
        coinsRequiered: Int,
        emailParent: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.timeRequiered = timeRequiered
        self.coinsRequiered = coinsRequiered
        self.emailParent = emailParent
    }
}
