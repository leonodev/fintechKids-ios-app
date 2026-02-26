//
//  LanguageModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 6/2/26.
//

import FHKUtils
import FHKCore
import FHKObservability
import FHKInjections
import FHKDomain

public struct LanguageModel {
    
    // Injections Dependency
    private var analitycsManager: any FHKAnalyticsProtocol {
        inject.analitycsManager
    }
    
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
    
    // Properties Accessibility
    public var menuLanguageIdentifier: String = "menu_language"
    
    private var _languageState: FHKCore.State<Never> = .loading
        var languageState: FHKCore.State<Never> {
            get { _languageState }
            set { _languageState = newValue
                switch newValue {
                    
                case .loaded:
                    informateLoadedState()
                    
                case .error(let error):
                    informateError(error)
                    
                default:
                    break
                }
            }
        }
    
    private func informateLoadedState() {
        Logger.info("LanguagesScreen loaded correctly with Languages downloaded")
    }
    
    private func informateError(_ error: any FHKError) {
        if error.isShouldTrack {
            analitycsManager.track(.error(.init(from: error)))
        }
        
        Logger.error(error.logMessage)
    }
}
