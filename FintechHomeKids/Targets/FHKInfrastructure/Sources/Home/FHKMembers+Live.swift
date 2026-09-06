//
//  FHKMembers+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 6/9/26.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public extension FHKMembers {
    
    static func live(supabaseClient: SupabaseClient) -> Self {
        var supabase = Self()
        let family = SupabaseFamily(supabaseClient: supabaseClient)
        
        supabase.addMembers = { members in
            try await family.createMembers(members: members)
        }
        
        supabase.fetchFamilyMembers = { emailParent in
            try await family.getFamilyMembers(parentEmail: emailParent)
        }
        
        supabase.deleteMember = { uuid in
            try await family.deleteMember(identification: uuid)
        }
        
        return supabase
    }
}

private struct SupabaseFamily: FHKSupabaseErrorProtocol {
    let supabaseClient: SupabaseClient
    
    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func createMembers(members: [FHKMemberEntity]) async throws {
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
    
    func getFamilyMembers(parentEmail: String) async throws -> [FHKMemberEntity] {
        do {
            let members: [FHKMemberDto] = try await supabaseClient
                .from(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.NAME)
                .select()
                .eq(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.COLUMN.email, value: parentEmail)
                .execute()
                .value
            
            return try members.toDomain()
        }
        catch let pgError as PostgrestError {
            let code = pgError.code ?? ""
            let errorToThrow = mapPostgresError(code, message: pgError.message)
            throw errorToThrow
        } catch {
            throw FHKSupabaseError.unknown(error.localizedDescription)
        }
    }
    
    func deleteMember(identification: UUID) async throws {
        do {
            try await supabaseClient.from(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.NAME)
                .delete()
                .eq(FHK_SUPABASE_DB.TABLE_FAMILY_MEMBER.COLUMN.identificationUUID, value: identification)
                .execute()
        }
        catch let pgError as PostgrestError {
            let code = pgError.code ?? ""
            let errorToThrow = mapPostgresError(code, message: pgError.message)
            throw errorToThrow
        } catch {
            throw FHKSupabaseError.unknown(error.localizedDescription)
        }
    }
}
