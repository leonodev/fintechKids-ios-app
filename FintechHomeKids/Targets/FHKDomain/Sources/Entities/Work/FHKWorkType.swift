//
//  FHKWorkType.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 20/9/26.
//

public enum FHKWorkType: String, Equatable, Sendable {
    case time = "time"
    case coins = "coins"
    
    public var value: String {
        return self.rawValue
    }
}
