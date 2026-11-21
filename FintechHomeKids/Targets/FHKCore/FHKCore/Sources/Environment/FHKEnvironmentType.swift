//
//  FHKEnvironmentType.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

public enum FHKEnvironmentType: String, Sendable {
    case production
    case stage
    case develop
    case localhost
    
    public static var current: FHKEnvironmentType {
        #if DEV
        return .develop
        #elseif QA
        return .stage
        #else
        return .production
        #endif
    }
    
    public var baseURL: String {
        switch self {
        case .production:
            return "https://fintechkids-backend.onrender.com"
            
        case .stage:
            return "https://fintechkids-backend-stage.onrender.com"
            
        case .develop:
            return "https://fintechkids-backend-dev.onrender.com"
            
        case .localhost:
            return "http://localhost:8000"
        }
    }
}
