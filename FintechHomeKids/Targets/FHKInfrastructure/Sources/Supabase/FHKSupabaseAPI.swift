//
//  FHKSupabaseAPI.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import Supabase
import FHKCore
import FHKDomain

public enum FHKSupabaseAPI {
    
    public static func makeClient(_ environment: EnvironmentType = .remote) throws -> SupabaseClient {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 30.0
        
        let customSession = URLSession(configuration: configuration)
        let urlString: String
        
        if environment == .localhost {
            urlString = "http://localhost:3001"
        } else {
            urlString = inject.fhkEnvironment.baseURL()
        }

        guard let url = URL(string: urlString) else {
            throw FHKAppError.invalidURL(urlString)
        }
        
        let anonKey = try inject.fhkSecurity.getAnonKey()
        
        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey,
            options: SupabaseClientOptions(
                db: .init(schema: "public"),
                auth: .init(autoRefreshToken: true),
                global: .init(session: customSession)
            )
        )
    }
}
