//
//  Screens+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 6/2/26.
//

import FHKObservability
import FHKConfig

public extension Screens {
    
    struct Language {  
        static let screen = AnalyticsEvent.Screen(
            name: "Language",
            screenClass: "LanguageScreen"
        )
        
        static func getBtnLanguag(lng: String) -> AnalyticsEvent.Button {
            switch lng {
            
            case Configuration.LanguageType.en.code():
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_EN")
                
            case Configuration.LanguageType.fr.code():
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_FR")
                
            case Configuration.LanguageType.it.code():
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_IT")
                
            default:
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_ES")
            }
        }
    }
}
