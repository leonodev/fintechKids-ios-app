//
//  ToastMock.swift
//  fintechKids
//
//  Created by fleon  on 11/6/26.
//

import FHKDomain

public final class ToastMock: @unchecked Sendable, FHKToastProtocol {
    public var currentToast: FHKToastInfo?
    public var isCalledShow = false
    public var passedDuration: Double?
    public var isVisible: Bool = false
    
    public func dismiss() {
        isCalledShow = true
        currentToast = nil
        isVisible = false
    }
    
    public func show(info: FHKToastInfo, duration: Double) {
        isCalledShow = true
        currentToast = info
        passedDuration = duration
        isVisible = true
    }
}
