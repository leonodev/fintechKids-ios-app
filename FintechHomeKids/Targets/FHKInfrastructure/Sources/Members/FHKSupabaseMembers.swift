//
//  FHKSupabaseMembers.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 17/9/26.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public struct FHKSupabaseMembers: Sendable, FHKSupabaseErrorProtocol {
    let supabaseClient: SupabaseClient
    
    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    public func addMembers(members: [FHKMemberEntity]) async throws {
        do {
            let membersDto = try members.toDto()
            
            let response = try await supabaseClient
                .from(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.NAME)
                .insert(membersDto)
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
    
    public func fetchFamilyMembers(parentEmail: String) async throws -> [FHKMemberEntity] {
        let members: [FHKMemberDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.COLUMN.email, value: parentEmail)
            .execute()
            .value
        
        return try members.toDomain()
    }
    
    public func deleteMember(identification: UUID) async throws {
        try await supabaseClient.from(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.NAME)
            .delete()
            .eq(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.COLUMN.identificationUUID, value: identification)
            .execute()
    }
}
