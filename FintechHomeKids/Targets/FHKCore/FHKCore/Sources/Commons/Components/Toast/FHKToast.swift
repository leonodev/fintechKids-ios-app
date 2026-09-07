//
//  FHKToast.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import Foundation
import FLibInjections

public struct FHKToast: Sendable {
    public var currentToast: @MainActor @Sendable () -> FHKToastInfo? = { nil }
    public var isVisible: @MainActor @Sendable () -> Bool = { false }
    public var show: @Sendable (FHKToastInfo, Double) -> Void = { _, _ in }
    public var dismiss: @Sendable () -> Void = { }
    
    public init() {}
}

@MainActor
public extension DependenciesInjection {
    
    var fhkToast: FHKToast {
        get { inject.get(FHKToast.self, live: .live, preview: .preview, testing: .test) }
        set { inject.set(newValue, for: FHKToast.self) }
    }
}


#if DEBUG
public extension FHKToast {
    
    static var test: Self {
        Self()
    }
    
    @MainActor
    static var preview: Self {
        var manager = Self()
        let service = FHKToastService()
        
        manager.currentToast = { @MainActor in
            FHKToastInfo(type: .success, message: "Toast Success Info", hasIcon: true)
        }
        
        manager.isVisible = { @MainActor in
            return false
        }
        
        manager.show = { info, duration in
            Task { @MainActor in service.show(info: info, duration: duration) }
        }
        
        manager.dismiss = {
            Task { @MainActor in service.dismiss() }
        }
        
        return manager
    }
}
#endif
