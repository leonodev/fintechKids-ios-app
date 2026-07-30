//
//  Int+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 17/3/26.
//

import Foundation
import FHKDomain
import FHKUtils

extension Int {
    func futureDateString(unit: DurationType) -> String {
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
