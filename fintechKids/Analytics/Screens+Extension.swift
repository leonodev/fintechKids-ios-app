//
//  Screens+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 6/2/26.
//

import FHKDomain
import FHKFirebase

public extension Screens {
    
    struct Language {  
        static let screen = AnalyticsEvent.Screen(
            name: "Language",
            screenClass: "LanguageScreen"
        )
        
        static func getBtnLanguag(lng: String) -> AnalyticsEvent.Button {
            switch lng {
            
            case LanguageType.en.code:
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_EN")
                
            case LanguageType.fr.code:
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_FR")
                
            case LanguageType.it.code:
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_IT")
                
            default:
                AnalyticsEvent.Button(name: "BTN_LANGUAGE_ES")
            }
        }
    }
}
