//
//  DependenciesInjection+App.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 3/9/26.
//

import Foundation
import FLibInjections
import FHKCore
import FHKDomain
import FHKInfrastructure

public extension DependenciesInjection {

    @MainActor
    static func registerMainApp() {
        do { 
            inject.fhkLanguage = .live
           
            let client = try FHKSupabaseAPI.makeClient()
            inject.fhkAuth = .live(client: client)
        } catch {
            fatalError("❌ Critical error during dependency registration: \(error)")
        }
    }
}
