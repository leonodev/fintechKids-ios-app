//
//  FHKBalanceRepository+Live.swift
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

public extension FHKBalanceRepository {
    
    static var live: Self {
        var repository = Self()
        
        repository.fetchBalance = { memberId in
            try await inject.fhkSupabaseBalance.fetchBalance(memberId)
        }
        
        repository.updateKidsCoinsBalance = { memberId, balanceCoins in
            try await inject.fhkSupabaseBalance.updateKidsCoinsBalance(memberId, balanceCoins)
        }
        
        repository.updateTimeBalance = { memberId, balanceTime in
            try await inject.fhkSupabaseBalance.updateTimeBalance(memberId, balanceTime)
        }
        
        repository.sendGoldenTicket = { ticketData in
            try await inject.fhkSupabaseBalance.sendGoldenTicket(ticketData)
        }
        
        return repository
    }
}
