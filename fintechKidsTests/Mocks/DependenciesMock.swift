//
//  DependenciesMock.swift
//  fintechKids
//
//  Created by fleon  on 10/6/26.
//

import FHKDomain
import Supabase
import Foundation
@testable import fintechKids

public final class DependenciesMock: FHKDependencies {
    
    static func makeSupabaseClientMock(_ environment: EnvironmentType = .develop) -> SupabaseClient {
        let dummyURL = URL(string: "https://dev.supabase.co")!
        return SupabaseClient(supabaseURL: dummyURL, supabaseKey: "mock-anon-key")
    }
}
