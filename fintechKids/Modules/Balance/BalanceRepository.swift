//
//  BalanceRepository.swift
//  fintechKids
//
//  Created by Fredy Leon on 30/3/26.
//

import Foundation
import FHKDomain
import FHKInjections
import FHKStorage
import FHKCore
import FHKUtils

final actor BalanceRepository: FHKBalanceRepositoryProtocol {
    
    // Properties injected
    private var fhkSupabaseBalance: any FHKSupabaseBalanceProtocol {
        inject.fhkSupabaseBalance
    }

    func fetchBalance(memberId: UUID) async throws -> BalanceEntity {
        try await fhkSupabaseBalance.fetchBalance(memberId: memberId)
    }
    
    func updateKidsCoinsBalance(memberId: UUID, infoBalance: BalanceKidsCoinsEntity) async throws {
        try await fhkSupabaseBalance.updateKidsCoinsBalance(memberId: memberId, infoBalance: infoBalance)
    }
    
    func updateTimeBalance(memberId: UUID, infoBalance: BalanceTimeEntity) async throws {
        try await fhkSupabaseBalance.updateTimeBalance(memberId: memberId, infoBalance: infoBalance)
    }
    
    func sendGoldenTicket(data: GoldenTicketParamsEntity) async throws {
        try await fhkSupabaseBalance.sendGoldenTicket(data: data)
    }
}
