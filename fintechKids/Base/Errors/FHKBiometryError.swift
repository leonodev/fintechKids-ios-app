//
//  FHKBiometryError.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/2/26.
//

import Foundation
import FHKCore
import FHKUtils

public enum FHKBiometryError: FHKError {

    case notAvailable
    case userCancelAuthentication
    
    public var logMessage: String {
        switch self {
        case .notAvailable:
            return "Biometry: hardware or permissions are not available on this device"
            
        case .userCancelAuthentication:
            return "Biometry: user explicitly cancelled the biometric authentication"
        }
    }
    
    public var messageUI: String {
        switch self {
        case .notAvailable:
            return "msn_biometry_not_available_error".localized().capitalizingFirstLetter()
            
        default:
            return ""
        }
    }
    
    /* We do not track these cases because they are not app errors,
      but rather device states or user decisions. */
    public var isShouldTrack: Bool {
        false
    }
}
