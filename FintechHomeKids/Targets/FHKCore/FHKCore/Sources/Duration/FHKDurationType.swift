//
//  FHKDurationType.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 20/9/26.
//

public enum FHKDurationType: String, Equatable {
    case hours = "hours"
    case days = "days"
    case weeks = "weeks"
    case months = "months"
    
    public var value: String {
        return self.rawValue
    }
     
}
