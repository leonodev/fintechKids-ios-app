//
//  FHKBalanceRepository+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public extension FHKBalanceRepository {
    
    static func live(supabaseClient: SupabaseClient) -> Self {
        var repository = Self()
        let balance = FHKSupabaseBalance(supabaseClient: supabaseClient)
        
        repository.fetchBalance = { memberId in
            try await balance.fetchBalance(memberId: memberId)
        }
        
        repository.updateKidsCoinsBalance = { memberId, amountBalance in
            try await balance.updateKidsCoinsBalance(memberId: memberId, infoBalance: amountBalance)
        }
        
        repository.updateTimeBalance = { memberId, timerBalance in
            try await balance.updateTimeBalance(memberId: memberId, infoBalance: timerBalance)
        }
        
        repository.sendGoldenTicket = { data in
            try await balance.sendGoldenTicket(data: data)
        }
        
        return repository
    }
}
