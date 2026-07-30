//
//  FHKAPIClientFactory.swift
//  fintechKids
//
//  Created by fleon  on 28/7/26.
//

import Foundation
import Supabase
import FHKInjections
import FHKConfig
import FHKCore
import FHKDomain

public enum FHKAPIClientFactory {
    private static var supabaseClient: SupabaseClient?
    
    public static func makeSupabaseClient(_ environment: EnvironmentType = .production) throws -> SupabaseClient {
        if let existingClient = supabaseClient {
            return existingClient
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 30.0
        
        let customSession = URLSession(configuration: configuration)
        let urlString: String
        
        // by example, to work with Mockoon
        if environment == .localhost {
            urlString = "http://localhost:3001"
        } else {
            urlString = try inject.fhkServicesAPI.getURL(environment, .spanish, .supabase)
        }

        guard let url = URL(string: urlString) else {
            throw FHKAppError.invalidURL(urlString)
        }
        
        let anonKey = try inject.fhkSecurity.getAnonKey()
        
        let client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey,
            options: SupabaseClientOptions(
                db: .init(schema: "public"),
                auth: .init(autoRefreshToken: true),
                global: .init(session: customSession)
            )
        )
        
        self.supabaseClient = client
        return client
    }
}
