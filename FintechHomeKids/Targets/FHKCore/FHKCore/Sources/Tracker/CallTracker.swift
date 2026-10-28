//
//  CallTracker.swift
//  fintechKids
//
//  Created by fleon  on 7/7/26.
//

import Foundation

public final class CallTracker: @unchecked Sendable {
    private let lock = NSLock()
    private var count = 0
    
    public init() {}
    
    /// Incrementa el contador de forma segura entre hilos.
    public func increment() {
        lock.lock()
        defer { lock.unlock() }
        count += 1
    }
    
    /// Devuelve el número total de llamadas de forma segura.
    public var callCount: Int {
        lock.lock()
        defer { lock.unlock() }
        return count
    }
    
    /// Evalúa si fue llamado al menos una vez de forma segura.
    public var isCalled: Bool {
        lock.lock()
        defer { lock.unlock() }
        return count > 0
    }
}
