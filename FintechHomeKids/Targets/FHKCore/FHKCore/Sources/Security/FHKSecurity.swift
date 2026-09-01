//
//  FHKSecurity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 31/8/26.
//

import Foundation

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
