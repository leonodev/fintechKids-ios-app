//
//  FHKVersionRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 19/11/2026.
//

import Foundation
import FHKDomain

public struct FHKVersionResponseDto: Decodable, Sendable {
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

    enum CodingKeys: String, CodingKey {
        case platform
        case currentVersion = "current_version"
        case latestVersion = "latest_version"
        case minRequiredVersion = "min_required_version"
        case isUpToDate = "is_up_to_date"
        case updateAvailable = "update_available"
        case forceUpdate = "force_update"
        case storeUrl = "store_url"
        case releaseNotes = "release_notes"
        case message
    }
}

public extension FHKVersionResponseDto {
    func toDomain() -> FHKAppVersionEntity {
        FHKAppVersionEntity(
            platform: platform,
            currentVersion: currentVersion,
            latestVersion: latestVersion,
            minRequiredVersion: minRequiredVersion,
            isUpToDate: isUpToDate,
            updateAvailable: updateAvailable,
            forceUpdate: forceUpdate,
            storeUrl: storeUrl,
            releaseNotes: releaseNotes,
            message: message
        )
    }
}

public extension FHKAppVersionParams {
    func toDto() -> FHKVersionRequestDto {
        FHKVersionRequestDto(platform: self.platform,
                             currentVersion: self.currentVersion
        )
    }
}
