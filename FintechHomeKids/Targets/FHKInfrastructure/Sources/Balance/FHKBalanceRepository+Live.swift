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
        var supabase = Self()
        let balance = FHKSupabaseBalance(supabaseClient: supabaseClient)
        
        supabase.fetchBalance = { memberId in
            try await balance.fetchBalance(memberId: memberId)
        }
        
        supabase.updateKidsCoinsBalance = { memberId, amountBalance in
            try await balance.updateKidsCoinsBalance(memberId: memberId, infoBalance: amountBalance)
        }
        
        supabase.updateTimeBalance = { memberId, timerBalance in
            try await balance.updateTimeBalance(memberId: memberId, infoBalance: timerBalance)
        }
        
        supabase.sendGoldenTicket = { data in
            try await balance.sendGoldenTicket(data: data)
        }
        
        return supabase
    }
}
