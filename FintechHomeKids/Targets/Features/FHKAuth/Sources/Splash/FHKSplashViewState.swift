//
//  FHKSplashViewState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import FLibUtils

public struct FHKSplashViewState {
    // Properties Screen View
    public var titleApp: String { "title_name_app".localized(.module) }
    public var subtitleApp: String { "title_kids".localized(.module) }
    
    public enum StateAction: Equatable {
        case goToLanguage
        case goToLogin
        case none
    }
    
    public enum State: Equatable {
        case loaded(nav: StateAction)
    }
    
    public var splashState: State = .loaded(nav: .none)
}
