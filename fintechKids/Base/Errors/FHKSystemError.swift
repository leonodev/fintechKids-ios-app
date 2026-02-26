//
//  FHKSystemError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/2/26.
//

import FHKDomain
import FHKUtils

public enum FHKSystemError: FHKError {
    case remoteConfigFailed
    
    public var logMessage: String {
        switch self {
        case .remoteConfigFailed:
            return "System: error getting remote configuration from server"
        }
    }
    
    public var messageUI: String {
        ""
    }
    
    // We need to monitor system errors.
    public var isShouldTrack: Bool {
        true
    }
}
