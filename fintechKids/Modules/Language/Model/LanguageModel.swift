//
//  LanguageModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 6/2/26.
//

import SwiftUI
import Combine
import FHKAuth
import FHKUtils
import FHKCore
import FHKConfig
import Observation

public struct LanguageModel {
    
    // Properties Screen View
    public var selectLanguageNow: String {
        "select_language_now".localized().capitalizingFirstLetter()
    }
    
    public var continueButtom: String {
        "continue".localized().capitalizingFirstLetter()
    }
    
    public var version: String {
        "version".localized()
    }
    
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
    
    // Properties Logs Error
    public let attributesLanguagesError = ["platform": "firebase",
                                           "paramater": "enabled_languages"]
    
    public let messageSaveLanguagesError = "Save Languages"
    public let attributesSaveLanguagesError = ["platform": "app",
                                               "key": "language_user",
                                               "storage": "user_default"]
    
    // Properties Accessibility
    public var menuLanguageIdentifier: String = "menu_language"
    
    private var _languageState: FHKCore.State<Never> = .loading
        var languageState: FHKCore.State<Never> {
            get { _languageState }
            set { _languageState = newValue
                switch newValue {
                    
                case .loaded:
                    informateLoadedState()
                    
                case .error(let log):
                    sendCrashlyticsError(log)
                    
                default:
                    break
                }
            }
        }
    
    private func informateLoadedState() {
        Logger.info("LanguagesScreen loaded correctly with Languages downloaded")
    }
    
    private func sendCrashlyticsError(_ error: Log) {
        CrashlyticsError.send(log: error)
    }
}
