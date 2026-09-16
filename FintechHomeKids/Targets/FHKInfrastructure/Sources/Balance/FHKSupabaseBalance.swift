//
//  FHKSupabaseBalance.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/9/26.
//

import Foundation
import Supabase
import FHKDomain
import FLibUtils
import PostgREST

public struct FHKSupabaseBalance: Sendable, FHKSupabaseErrorProtocol {
    let supabaseClient: SupabaseClient
    
    public init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    public func fetchBalance(memberId: UUID) async throws -> FHKBalanceEntity {
        let balances: [FHKBalanceDto] = try await supabaseClient
            .from(FHK_SUPABASE_DB.TABLE_BALANCE.NAME)
            .select()
            .eq(FHK_SUPABASE_DB.TABLE_BALANCE.COLUMN.memberId, value: memberId)
            .execute()
            .value
        
        guard let balance = balances.first else {
            return FHKBalanceEntity(
                memberId: memberId,
                coinsObtained: 0,
                timeObtained: "0"
            )
        }
        
        return balance.toDomain()
    }
    
    public func updateKidsCoinsBalance(memberId: UUID, infoBalance: FHKBalanceKidsCoinsEntity) async throws {
        do {
            let coinsParams = FHKCoinsRewardsParamsDto(
                target_member_id: memberId,
                new_coins: infoBalance.coinsObtained
            )
            
            let response = try await supabaseClient.rpc(
                FHK_SUPABASE_DB.TABLE_BALANCE.FUNCTION_RPC.updateCoinsBalance,
                params: coinsParams
            ).execute()
            
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
    
    public func updateTimeBalance(memberId: UUID, infoBalance: FHKBalanceTimeEntity) async throws {
        do {
            let timeParams = FHKTimeRewardsParamsDto(
                target_member_id: memberId,
                new_time_string: infoBalance.timeObtained
            )
            
            let response = try await supabaseClient.rpc(
                FHK_SUPABASE_DB.TABLE_BALANCE.FUNCTION_RPC.updateTimeBalance,
                params: timeParams
            ).execute()
            
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
    
    public func sendGoldenTicket(data: FHKGoldenTicketParamsEntity) async throws {
        do {
            let response: ResendResponse = try await supabaseClient.functions
                .invoke(
                    "resend-email",
                    options: FunctionInvokeOptions(body: data)
                )
            
            if let emailId = response.id {
                print("✅ Ticket enviado con éxito. ID de Resend: \(emailId)")
            }
        } catch {
            print("❌ Error al enviar el Ticket Dorado: \(error)")
            throw error
        }
    }
}


