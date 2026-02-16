//
//  String+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/12/25.
//

import Foundation
import FHKConfig
import FHKInjections

public extension String {
    func localized() -> String {
        
        // Injections Dependency
        let languageManager = inject.languageManager
        
        guard let path = Bundle.main.path(forResource: languageManager.selectedLanguage,
                                          ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }

        return bundle.localizedString(forKey: self, value: nil, table: "Localizable")
    }
}
