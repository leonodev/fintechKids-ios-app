//
//  FHKEnvironment.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation
import FLibInjections

public struct FHKEnvironment: Sendable {
    public var baseURL: @Sendable() -> String = { "" }
    public var appName: @Sendable() -> String = { "" }
    
    public init() {}
}

public extension DependenciesInjection {
    
    var fhkEnvironment: FHKEnvironment {
        get { inject.get(FHKEnvironment.self, live: .live, preview: .preview, testing: .test) }
        set { inject.set(newValue, for: FHKEnvironment.self) }
    }
}

#if DEBUG
extension FHKEnvironment {
    
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var view = Self()
        
        view.baseURL = {
            return "https://preview.fintechhomekids.com"
        }
        
        view.appName = {
            return "fintechhomekids-preview"
        }
        
        return view
    }
}


#endif
