//
//  String+Extension.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

import Foundation

public extension String {
    
    var toIntOrZero: Int {
        Int(self) ?? 0
    }
}
