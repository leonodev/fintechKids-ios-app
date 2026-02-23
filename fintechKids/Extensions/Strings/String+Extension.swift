//
//  String+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/12/25.
//

import Foundation
import FHKConfig
import FHKInjections
import FHKCore

public extension String {
    func localized() -> String {
        
        var bundle: Bundle {
            inject.languageManager.currentBundle
        }
        return bundle.localizedString(forKey: self, value: nil, table: "Localizable")
    }
}
