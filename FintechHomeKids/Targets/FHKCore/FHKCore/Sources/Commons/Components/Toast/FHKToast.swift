//
//  FHKToast.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import Foundation

public struct FHKToast: Sendable {
    public var currentToast: @MainActor @Sendable () -> FHKToastInfo? = { nil }
    public var isVisible: @MainActor @Sendable () -> Bool = { false }
    public var show: @Sendable (FHKToastInfo, Double) -> Void = { _, _ in }
    public var dismiss: @Sendable () -> Void = { }
    
    public init() {}
}
