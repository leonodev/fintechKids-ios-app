//
//  Bundle+Extension.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 19/11/2026.
//

import Foundation
public extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
