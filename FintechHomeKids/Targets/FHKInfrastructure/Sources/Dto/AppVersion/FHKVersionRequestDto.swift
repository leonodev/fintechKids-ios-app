//
//  FHKVersionRequestDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/11/2026.
//

public struct FHKVersionRequestDto: Encodable, Sendable {
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
