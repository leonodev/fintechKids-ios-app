//
//  FHKSecurity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation
import FLibInjections

public enum BiometryType {
    case faceID
    case touchID
    case none
}

public struct FHKSecurity: Sendable {
    public var getBiometryType: @Sendable () -> BiometryType = { .none }
    public var getAnonKey: @Sendable () throws -> String = { "" }
    public var biometryIcon: @Sendable () -> String = { "" }
    
    public init() {}
}

public extension DependenciesInjection {
    var fhkSecurity: FHKSecurity {
        get { inject.get(FHKSecurity.self, preview: .preview, testing: .test) }
        set { inject.set(newValue, for: FHKSecurity.self) }
    }
}

#if DEBUG
public extension FHKSecurity {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        return preview
    }
}
#endif
