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

public extension FHKRewardEntity {
    /// Return cost of rewards in hours 
    var requiredHours: Int {
        timeRequiered.asHours
    }
}


#if DEBUG
public extension FHKRewardEntity {
    static func previewItem(_ count: Int) -> [Self] {
        var previewItems = [Self]()
        
        for i in 1...count {
            let item = FHKRewardEntity(id: i,
                                       createdAt: Date().toUTC,
                                       name: "Go to Karting \(i)",
                                       timeRequiered: "6 hours",
                                       coinsRequiered: 300,
                                       emailParent: "parent@domain.com")
            
            previewItems.append(item)
        }
        
        return previewItems
    }
}

#endif
