//
//  SecurityMock.swift
//  fintechKids
//
//  Created by fleon  on 11/6/26.
//

import Foundation
import FHKDomain
import Supabase

public final class SecurityMock: @unchecked Sendable, FHKSecurityProtocol {
    private let lock = NSLock()
    private var _biometryType: BiometryType
    
    public var biometryType: BiometryType {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _biometryType
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _biometryType = newValue
        }
    }
    
    public init(type: BiometryType) {
        self._biometryType = type
    }
    
    public func getBiometryType() -> BiometryType {
        lock.lock()
        defer { lock.unlock() }
        return self._biometryType
    }
    
    public var biometryIcon: String {
        switch getBiometryType() {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return ""
        }
    }
    
    public func getAnonKey() throws -> String {
        return "4234DF"
    }
}
