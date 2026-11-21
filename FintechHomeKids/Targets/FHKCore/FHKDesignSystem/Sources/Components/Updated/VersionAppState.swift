//
//  VersionAppState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 20/11/2026.
//

public enum VersionAppState: Sendable {
    case recommendedUpdate
    case requiredUpdate
    case upToDate
    case undefined
    case error
    
    public static func evaluate(
        currentVersion: String,
        latestVersion: String,
        forceUpdate: Bool = false
    ) -> VersionAppState {
        guard let currentParts = parseVersion(currentVersion),
              let latestParts = parseVersion(latestVersion) else {
            return .undefined
        }
        
        let maxCount = max(currentParts.count, latestParts.count)
        
        for index in 0..<maxCount {
            let current = index < currentParts.count ? currentParts[index] : 0
            let latest = index < latestParts.count ? latestParts[index] : 0
            
            if current < latest {
                return forceUpdate ? .requiredUpdate : .recommendedUpdate
            } else if current > latest {
                return .upToDate
            }
        }
        
        return .upToDate
    }
    
    private static func parseVersion(_ version: String) -> [Int]? {
        let trimmed = version.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        
        let components = trimmed.split(separator: ".", omittingEmptySubsequences: false)
        var numbers: [Int] = []
        
        for part in components {
            guard let num = Int(part), num >= 0 else { return nil }
            numbers.append(num)
        }
        
        return numbers.isEmpty ? nil : numbers
    }
}
