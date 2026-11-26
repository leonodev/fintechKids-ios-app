//
//  FHKAppVersionParams.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/11/2026.
//

public struct FHKAppVersionParams: Sendable {
    public let platform: String
    public let currentVersion: String

    public init(platform: String, currentVersion: String) {
        self.platform = platform
        self.currentVersion = currentVersion
    }
}
