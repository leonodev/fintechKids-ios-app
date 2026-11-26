//
//  FHKCheckVersionRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/11/2026.
//

import FHKDomain

public struct FHKCheckVersionRequestDto: Encodable, Sendable {
    public let platform: String
    public let currentVersion: String

    enum CodingKeys: String, CodingKey {
        case platform
        case currentVersion = "current_version"
    }

    public init(platform: String, currentVersion: String) {
        self.platform = platform
        self.currentVersion = currentVersion
    }
}

public extension FHKAppVersionParams {
    func toDto() -> FHKCheckVersionRequestDto {
        FHKCheckVersionRequestDto(
            platform: self.platform,
            currentVersion: self.currentVersion
        )
    }
}
