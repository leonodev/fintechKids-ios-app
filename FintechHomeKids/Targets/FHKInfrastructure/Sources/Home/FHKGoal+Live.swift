//
//  FHKGoal+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public extension FHKGoal {
    
    static func live(supabaseClient: SupabaseClient) -> Self {
        var supabase = Self()
        let supabaseGoal = SupabaseGoal(supabaseClient: supabaseClient)
        
        supabase.createGoal = { goalEntity in
            try await supabaseGoal.createGoal(goal: goalEntity)
        }
        
        supabase.getGoals = { emailParent in
            try await supabaseGoal.getGoals(emailParent: emailParent)
        }
        
        supabase.createGoalMember = { goal in
            try await supabaseGoal.createGoalMember(goal: goal)
        }
        
        supabase.fetchGoalMember = { uuid in
            try await supabaseGoal.fetchGoalMember(memberId: uuid)
        }
        
        supabase.fetchGoalMemberFamily = { emailParent in
            try await supabaseGoal.fetchGoalMemberFamily(emailParent: emailParent)
        }
        
        return supabase
    }
}

private struct SupabaseGoal: Sendable, FHKSupabaseErrorProtocol {
    let supabaseClient: SupabaseClient
    
    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    public func createGoal(goal: FHKGoalEntity) async throws {
        do {
            let goalDto = try goal.toDto()

            let response = try await supabaseClient
                .from(FHK_SUPABASE_DB.TABLE_GOAL.NAME)
                .insert(goalDto)
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
    
    public func getGoals(emailParent: String) async throws -> [FHKGoalEntity] {
        let goalList: [FHKGoalDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_GOAL.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_GOAL.COLUMN.emailParent, value: emailParent)
            .execute()
            .value
        
        return try goalList.toDomain()
    }
    
    public func createGoalMember(goal: FHKGoalMemberEntity) async throws {
        let goalMemberDto = try goal.toDto()
        try await supabaseClient.functions.invoke(
            FHK_SUPABASE_DB.TABLE_GOALS_MEMBER.FUNCTION_EDGE.upsertGoalMember,
            options: FunctionInvokeOptions(
                body: goalMemberDto
            )
        )
    }
    
    public func fetchGoalMember(memberId: UUID) async throws -> [FHKGoalMemberEntity] {
        let goalMemberList: [FHKGoalMemberDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_GOALS_MEMBER.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_GOALS_MEMBER.COLUMN.memberId, value: memberId)
            .execute()
            .value
        
        return try goalMemberList.toDomain()
    }
    
    public func fetchGoalMemberFamily(emailParent: String) async throws -> [FHKGoalMemberEntity] {
        let goalMemberFamilyList: [FHKGoalMemberDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_GOALS_MEMBER.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_GOALS_MEMBER.COLUMN.parentEmail, value: emailParent)
            .execute()
            .value
        
        return try goalMemberFamilyList.toDomain()
    }
}
