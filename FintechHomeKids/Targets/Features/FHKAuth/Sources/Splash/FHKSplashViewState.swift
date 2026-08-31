//
//  FHKSplashViewState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import FLibUtils

@MainActor
public struct FHKSplashViewState {
    // Properties Screen View
    public var titleApp: String {
        "title_name_app".localized
    }
    
    public var subtitleApp: String {
        "title_kids".localized
    }
    
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
