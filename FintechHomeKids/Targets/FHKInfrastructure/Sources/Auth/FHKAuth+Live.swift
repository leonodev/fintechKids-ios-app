//
//  FHKAuth+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import Supabase
import PostgREST
import FHKDomain
import FLibUtils
import FHKDomain

public extension FHKAuth {
    
    static func live(client: SupabaseClient) -> Self {
        let supabaseService = FHKSupabase(client: client)
        
        var auth = Self()
        
        auth.login = { entity in
            try await supabaseService.login(loginEntity: entity)
        }
        
        auth.logout = {
            try await supabaseService.logout()
        }
        
        auth.refreshSession = { email in
            try await supabaseService.refreshSession(emailParent: email)
        }
        
        auth.register = { entity in
            try await supabaseService.register(registerEntity: entity)
        }
        
        auth.setSession = { token in
            try await supabaseService.setSession(accessToken: token)
        }
        
        auth.isUserAuthenticated = {
            await supabaseService.isUserAuthenticated
        }
        
        return auth
    }
}

internal struct FHKSupabase: Sendable, FHKSupabaseErrorProtocol {
    private let client: SupabaseClient
    
    public init(client: SupabaseClient) {
        self.client = client
    }
    
    public func login(loginEntity: LoginEntity) async throws -> FHKUserSession {
        do {
            let session = try await client.auth.signIn(email: loginEntity.email,
                                                       password: loginEntity.password)
            let aditionalInfo = try await loadAditionalInformation(emailParent: loginEntity.email)
            return session.toDomain(aditionalInfo: aditionalInfo)
        } catch {
            throw handleAuthError(error, context: loginEntity.toSafeLogString())
        }
    }
    
    public func register(registerEntity: FHKRegisterEntity) async throws -> FHKUserSession {
        do {
            let signUp = try await client.auth.signUp(
                email: registerEntity.email,
                password: registerEntity.password
            )
            
            let familyData: [String: String] = [
                FHK_SUPABASE_DB.TABLE_FAMILIES.COLUMN.emailParent: registerEntity.email,
                FHK_SUPABASE_DB.TABLE_FAMILIES.COLUMN.nameFamily: registerEntity.familyName.lowercased(),
                FHK_SUPABASE_DB.TABLE_FAMILIES.COLUMN.approvePin: registerEntity.approvePIN
            ]
    
            try await client
                .from(FHK_SUPABASE_DB.TABLE_FAMILIES.NAME)
                .insert(familyData)
                .execute()
            
            let aditionalInfo = InfoAditional(pinApproved: registerEntity.approvePIN,
                                              familyName: registerEntity.familyName.lowercased())
            
            return signUp.toDomain(aditionalInfo: aditionalInfo)
            
        } catch {
            throw handleAuthError(error, context: registerEntity.toSafeLogString())
        }
    }
    
    public func logout() async throws {
        try await client.auth.signOut()
    }
    
    public func refreshSession(emailParent: String) async throws -> FHKUserSession {
        let session = try await client.auth.refreshSession()
        
        let aditionalInfo = try await loadAditionalInformation(emailParent: emailParent)
        return session.toDomain(aditionalInfo: aditionalInfo)
    }

    public var isUserAuthenticated: Bool {
        get async {
            return client.auth.currentUser != nil
        }
    }
    
    public func setSession(accessToken: String) async throws {
        try await client.auth.setSession(accessToken: accessToken, refreshToken: "")
    }

}

// MARK: Private Methods
private extension FHKSupabase {
    
    func fetchInfoFamily(parentEmail: String) async throws -> FamilyInfoResponse {
        do {
            let result: FamilyInfoResponse = try await client
                .from(FHK_SUPABASE_DB.TABLE_FAMILIES.NAME)
                .select(FHK_SUPABASE_DB.TABLE_FAMILIES.SELECT_FAMILY_INFO)
                .eq(FHK_SUPABASE_DB.TABLE_FAMILIES.COLUMN.emailParent, value: parentEmail)
                .single()
                .execute()
                .value
            
            return result
        } catch {
            throw FHKSupabaseError.unknown("error fetching family info")
        }
    }
}

// MARK: Handle Errors
private extension FHKSupabase {
    
    func handleAuthError(_ error: Error, context: String? = nil) -> Error {
        if let authError = error as? AuthError {
            return mapToDomainError(authError, context: context)
        }
        
        if let authError = error as? PostgrestError {
            let errorPostgres = mapPostgresError(authError.code ?? "", message: context ?? "")
            return errorPostgres
        }
        return FHKSupabaseError.unknown(error.localizedDescription)
    }
    
    func mapToDomainError(_ error: AuthError, context: String?) -> FHKSupabaseError {
        
        switch error {
        case .api(_, let errorCode, _, _):
            let baseError = FHKSupabaseError.from(errorCode: errorCode.rawValue)
            
            if case .invalidCredentials = baseError {
                return .invalidCredentials(context: context)
            }
            if case .userAlreadyExists = baseError {
                return .userAlreadyExists(context: context)
            }
            
            return baseError
        default:
            return .unknown(error.localizedDescription)
        }
    }
    
    func loadAditionalInformation(emailParent: String) async throws -> InfoAditional? {
        async let info = try fetchInfoFamily(parentEmail: emailParent)
        
        let (approvedPin, familyName) = try await (info.approve_pin,
                                                   info.name_family)
        return InfoAditional(pinApproved: approvedPin, familyName: familyName)
    }
}


struct FamilyInfoResponse: Decodable {
    let approve_pin: String
    let name_family: String
}
