//
//  Analytics.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

// Contrato/Cliente de dependencias
public struct FHKAnalytics: Sendable {
    public var track: @Sendable (AnalyticsEvent) -> Void
    
    public init(track: @escaping @Sendable (AnalyticsEvent) -> Void = { _ in }) {
        self.track = track
    }
}
