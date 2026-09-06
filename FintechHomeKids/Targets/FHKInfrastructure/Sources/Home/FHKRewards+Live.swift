//
//  FHKRewards+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public extension FHKRewards {
    
    static func live(supabaseClient: SupabaseClient) -> Self {
        var rewards = Self()
        let supabase = SupabaseRewards(supabaseClient: supabaseClient)
        
        rewards.createReward = { reward in
            try await supabase.createReward(reward: reward)
        }
        
        rewards.fetchRewards = { emailParent in
            try await supabase.fetchRewards(emailParent: emailParent)
        }
        
        rewards.fetchRewardCollected = { parentEmail in
            try await supabase.fetchRewardCollected(parentEmail: parentEmail)
        }
        
        return rewards
    }
}

public struct SupabaseRewards: Sendable, FHKSupabaseErrorProtocol {
    let supabaseClient: SupabaseClient
    
    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    public func createReward(reward: FHKRewardEntity) async throws {
        do {
            let rewardDto = try reward.toDto()

            let response = try await supabaseClient
                .from(FHK_SUPABASE_DB.TABLE_REWARDS_LIST.NAME)
                .insert(rewardDto)
                .execute()
            
            if response.status >= 400 {
                throw FHKSupabaseError.unknown("Error unknown: \(response.status)")
            }
        } catch let pgError as PostgrestError {
            let code = pgError.code ?? ""
            let errorToThrow = mapPostgresError(code, message: pgError.message)
            throw errorToThrow
        } catch {
            throw FHKSupabaseError.unknown(error.localizedDescription)
        }
    }
    
    public func fetchRewards(emailParent: String) async throws -> [FHKRewardEntity] {
        let rewardList: [FHKRewardDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_REWARDS_LIST.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_REWARDS_LIST.COLUMN.emailParent, value: emailParent)
            .execute()
            .value
        
        return try rewardList.toDomain()
    }
    
    public func fetchRewardCollected(parentEmail: String) async throws -> [FHKRewardCollectedEntity] {
        let response: [FHKRewardCollectedDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_REWARDS_COLLECTED.NAME)
            .select(FHK_SUPABASE_DB.TABLE_REWARDS_COLLECTED.JOIN_FAMILY_MEMBER)
            .eq(FHK_SUPABASE_DB.TABLE_REWARDS_COLLECTED.COLUMN.parentEmail, value: parentEmail)
            .order(FHK_SUPABASE_DB.TABLE_REWARDS_COLLECTED.COLUMN.createdAt, ascending: false)
            .execute()
            .value

        return try response.toDomain()
    }
}
