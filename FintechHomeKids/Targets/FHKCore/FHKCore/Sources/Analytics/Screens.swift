//
//  Screens.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

public enum Screens {}

public extension Screens {
    static let contentView = AnalyticsEvent.Screen(
        name: "ContentView",
        screenClass: "ContentView"
    )
}

public extension Screens {
    
    struct FHKLanguage {
        public static let screen = AnalyticsEvent.Screen(
            name: "Language",
            screenClass: "LanguageScreen"
        )
        
        public static func getBtnLanguag(lng: String) -> AnalyticsEvent.Button {
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
