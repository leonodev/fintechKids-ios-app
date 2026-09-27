//
//  AnyHashableSendable.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 27/9/26.
//

import Foundation

public struct AnyHashableSendable: Hashable, Sendable {
    public let base: any Hashable & Sendable
    
    public init<T: Hashable & Sendable>(_ base: T) {
        self.base = base
    }
    
    public static func == (lhs: AnyHashableSendable, rhs: AnyHashableSendable) -> Bool {
        AnyHashable(lhs.base) == AnyHashable(rhs.base)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(AnyHashable(base))
    }
}

public extension Hashable where Self: Sendable {
    var asPayload: AnyHashableSendable {
        AnyHashableSendable(self)
    }
}

public extension AnyHashableSendable {
    func value<T>(as type: T.Type = T.self) -> T? {
        base as? T
    }
}
