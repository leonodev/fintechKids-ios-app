//
//  FHKEnvironment+Live.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation

public extension FHKEnvironment {
    
    static var live: Self {
        var env = Self()
        
        env.baseURL = {
            guard let url = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
                fatalError("❌ BASE_URL no encontrada en Info.plist")
            }
            return url
        }
        
        env.appName = {
            guard let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else {
                return "FintechHomeKids"
            }
            return name
        }
        
        return env
    }
}
