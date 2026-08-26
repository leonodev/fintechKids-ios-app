//
//  FHKEnvironment.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import Foundation

public struct FHKEnvironment: Sendable {
    public var baseURL: @Sendable() -> String = { "" }
    public var appName: @Sendable() -> String = { "" }
    
    public init() {}
}
