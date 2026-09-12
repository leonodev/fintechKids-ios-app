//
//  FHKPermission.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 11/9/26.
//

import Foundation
import FLibInjections

// MARK: - Contract
public enum PermissionStatus {
    case notDetermined, authorized, denied
}

public struct FHKPermission: Sendable {
    public var title: @MainActor @Sendable () -> String = { "" }
    public var message: @MainActor @Sendable () -> String = { "" }
    public var status: @MainActor @Sendable () -> PermissionStatus = { .notDetermined }
    public var titleButtonSetting: @MainActor @Sendable () -> String = { "" }
    public var titleButtonLater: @MainActor @Sendable () -> String = { "" }
    public var requestPermission: @MainActor @Sendable () async -> PermissionStatus = { .denied }

    public init() {}
}


// MARK: - KeyPath Access
public extension DependenciesInjection {
    
    var fhkCameraPermission: FHKPermission {
        get { get(FHKPermission.self, preview: .preview, testing: .test) }
        set { set(newValue, for: FHKPermission.self) }
    }
}


// MARK: - Mocks & Previews
#if DEBUG
public extension FHKPermission {
    static var test: Self {
        Self()
    }
    
    static var preview: Self {
        var preview = Self()
        
        preview.title = {
            "Title Permission"
        }
        
        preview.message = {
            "This is a example of messagge"
        }
        
        preview.status = {
            .authorized
        }
        
        preview.titleButtonSetting = {
            "Title Setting"
        }
        
        preview.titleButtonLater = {
            "Title Later"
        }
        
        preview.requestPermission = {
            .authorized
        }
        
        return preview
    }
}

#endif
