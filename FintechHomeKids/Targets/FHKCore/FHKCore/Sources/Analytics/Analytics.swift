//
//  Analytics.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import FLibInjections

// Contrato/Cliente de dependencias
public struct FHKAnalytics: Sendable {
    public var track: @Sendable (AnalyticsEvent) -> Void
    
    public init(track: @escaping @Sendable (AnalyticsEvent) -> Void = { _ in }) {
        self.track = track
    }
}

public extension DependenciesInjection {
    var fhkAnalitycs: FHKAnalytics {
        get { get(FHKAnalytics.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKAnalytics.self) }
    }
    
}

#if DEBUG
public extension FHKAnalytics {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.track = { info in
            
        }
        
        return preview
    }
}
#endif
