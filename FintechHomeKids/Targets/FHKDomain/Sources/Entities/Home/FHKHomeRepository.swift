//
//  FHKHomeRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKHomeRepository: Sendable {
    
    public var fetchMembers:
    @Sendable(String, Bool) async throws -> [FHKMemberEntity] = { _, _ in [] }
    
    public var fetchRewardCollected:
    @Sendable(String, Bool) async throws -> [FHKRewardCollectedEntity] = { _, _ in [] }
    
    public var getParentMail:
    @Sendable() async -> String? = { nil }
    
    public var getMemberById:
    @Sendable (_ memberId: UUID) async throws -> FHKMemberEntity? = { _ in nil }
    
    public init() {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkHomeRepository: FHKHomeRepository {
        get { get(FHKHomeRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKHomeRepository.self) }
    } 
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKHomeRepository {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.fetchMembers = { _, _ in
            [FHKMemberEntity.previewItem]
        }
        
        preview.fetchRewardCollected = { _, _ in
            FHKRewardCollectedEntity.previewItem(2)
        }
        
        preview.getParentMail = {
            "parent@domain.com"
        }
        
        preview.getMemberById = { _ in
            FHKMemberEntity(emailParent: "parent@domain.com",
                            memberName: "new member",
                            familyName: "Members Family")
        }
        
        return preview
    }
}


public extension FHKMemberEntity {
    static var previewItem: Self {
        FHKMemberEntity(emailParent: "parent@domain.com",
                        memberName: "New Member",
                        familyName: "Family Dummy")
    }
}

public extension FHKRewardCollectedEntity {
    static func previewItem(_ count: Int) -> [Self] {
        var previewItems = [Self]()
        
        for i in 1...count {
            let item = FHKRewardCollectedEntity(id: 1,
                                                createdDate: Date().toUTC,
                                                member: FHKMemberEntity.previewItem,
                                                parentEmail: "parent@domain.com",
                                                nameReward: "Go to Karting \(i)",
                                                claimedValue: "200 KidsCoins",
                                                state: "PENDING",
                                                nameTask: "pass the school term exams")
            previewItems.append(item)
        }
        
        return previewItems
    }
}

#endif
