//
//  FHKTaskEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

import Foundation
import FHKCore

public struct FHKTaskEntity: DomainModelProtocol {
    public let id: UUID = UUID()
    public let createdAt: String
    public let name: String
    public let description: String
    public let timeGranted: String
    public let coinsGranted: Int
    public let emailParent: String
    
    public init(createdAt: String,
                name: String,
                description: String,
                timeGranted: String,
                coinsGranted: Int,
                emailParent: String
    ) {
        self.createdAt = createdAt
        self.name = name
        self.description = description
        self.timeGranted = timeGranted
        self.coinsGranted = coinsGranted
        self.emailParent = emailParent
    }
}


#if DEBUG
public extension FHKTaskEntity {
    
    static var previewItem: Self {
        FHKTaskEntity(createdAt: Date().toUTC,
                      name: "Task Preview",
                      description: "Preview Description",
                      timeGranted: "2 hours",
                      coinsGranted: 30,
                      emailParent: "email@test.com")
    }
}
#endif
