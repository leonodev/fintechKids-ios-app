//
//  Int+Extension.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 20/9/26.
//

import Foundation
import FLibUtils

public extension Int {
    func futureDateString(unit: FHKDurationType) -> String {
        let calendar = Calendar.current
        var components = DateComponents()
        
        switch unit {
        case .hours:  components.hour = self
        case .days:   components.day = self
        case .weeks:  components.day = self * 7
        case .months: components.month = self
        }
        
        let date = calendar.date(byAdding: components, to: Date()) ?? Date()
        return date.toUTC
    }
}
