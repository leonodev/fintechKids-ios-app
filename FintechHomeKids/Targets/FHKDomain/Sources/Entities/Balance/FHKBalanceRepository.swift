//
//  FHKBalanceRepository.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public struct FHKBalanceRepository: Sendable {
    
    public var fetchBalance:
    @Sendable(UUID) async throws -> FHKBalanceEntity = { _ in
        throw FHKAuthError.userNotFound
    }
    
    public var updateKidsCoinsBalance:
    @Sendable(UUID, FHKBalanceKidsCoinsEntity) async throws -> Void = { _, _ in }
    
    public var updateTimeBalance:
    @Sendable(UUID, FHKBalanceTimeEntity) async throws -> Void = { _, _ in }
    
    public var sendGoldenTicket:
    @Sendable(FHKGoldenTicketParamsEntity) async throws -> Void = { _ in }
    
    public init () {}
}

// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkBalanceRepository: FHKBalanceRepository {
        get { get(FHKBalanceRepository.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKBalanceRepository.self) }
    }
}

// MARK: - Mocks & Previews
#if DEBUG
extension FHKBalanceRepository {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.fetchBalance = { id in
            FHKBalanceEntity(memberId: id, coinsObtained: 100, timeObtained: "2 hours")
        }
        
        return preview
    }
}
#endif
