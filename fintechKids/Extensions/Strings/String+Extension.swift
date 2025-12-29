//
//  String+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 25/12/25.
//

import Foundation
import FHKConfig

public extension String {
    func localized() -> String {
        let langCode = LanguageManager.shared.selectedLanguage
        
        print("DEBUG: Buscando carpeta para el código: '\(langCode)'")
        guard let path = Bundle.main.path(forResource: langCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }

        return bundle.localizedString(forKey: self, value: nil, table: "Localizable")
    }
}
