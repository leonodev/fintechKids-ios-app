//
//  FHKSupabaseTask.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 11/11/2026.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public struct FHKSupabaseTask: Sendable, FHKSupabaseErrorProtocol {
    let supabaseClient: SupabaseClient
    
    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    public func createTask(task: FHKTaskEntity) async throws {
        do {
            let taskDto = try task.toDto()
            
            let response = try await supabaseClient
                .from(FHK_SUPABASE_DB.TABLE_TASK.NAME)
                .insert(taskDto)
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
    
    public func fetchTaskList(parentEmail: String) async throws -> [FHKTaskEntity] {
        let members: [FHKTaskDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_TASK.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_TASK.COLUMN.email, value: parentEmail)
            .execute()
            .value
        
        return try members.toDomain()
    }
}
