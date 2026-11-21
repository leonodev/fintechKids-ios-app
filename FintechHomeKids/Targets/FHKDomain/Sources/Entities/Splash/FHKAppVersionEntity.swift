//
//  FHKAppVersionResponse.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 19/11/2026.
//

import Foundation

public struct FHKAppVersionEntity: Sendable, Equatable {
    public let platform: String
    public let currentVersion: String
    public let latestVersion: String
    public let minRequiredVersion: String
    public let isUpToDate: Bool
    public let updateAvailable: Bool
    public let forceUpdate: Bool
    public let storeUrl: String?
    public let releaseNotes: String?
    public let message: String

    public init(
        platform: String,
        currentVersion: String,
        latestVersion: String,
        minRequiredVersion: String,
        isUpToDate: Bool,
        updateAvailable: Bool,
        forceUpdate: Bool,
        storeUrl: String?,
        releaseNotes: String?,
        message: String
    ) {
        self.platform = platform
        self.currentVersion = currentVersion
        self.latestVersion = latestVersion
        self.minRequiredVersion = minRequiredVersion
        self.isUpToDate = isUpToDate
        self.updateAvailable = updateAvailable
        self.forceUpdate = forceUpdate
        self.storeUrl = storeUrl
        self.releaseNotes = releaseNotes
        self.message = message
    }
}
