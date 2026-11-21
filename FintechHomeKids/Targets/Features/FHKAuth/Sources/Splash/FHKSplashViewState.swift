//
//  FHKSplashViewState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import FLibUtils
import FHKDesignSystem

@MainActor
public struct FHKSplashViewState {
    // Properties Screen View
    public var titleApp: String {
        "title_name_app".localized
    }
    
    public var subtitleApp: String {
        "title_kids".localized
    }
    
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
    
    public var latestVersion: String = ""
    public var releaseNotes: String = ""
    public var storeUrl: String = ""
    
    public enum StateAction: Equatable, Sendable {
        case goToLanguage
        case goToLogin
        case gotoHome
        case none
    }
    
    public enum State: Equatable, Sendable {
        case loading
        case loaded(nav: StateAction)
        case versionApp(state: VersionAppState)
    }
    
    public var splashState: State = .loaded(nav: .none)
}
