//
//  SplashViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/2/26.
//

import FHKUtils

public struct SplashViewState {
    // Properties Screen View
    public let titleApp: String = "title_name_app".localized()
    public let subtitleApp: String = "title_kids".localized()
    
    public enum StateAction: Equatable {
        case goToLanguage
        case goToLogin
        case gotoHome
        case none
    }
    
    public enum State: Equatable {
        case loaded(nav: StateAction)
    }
    
    public var splashState: State = .loaded(nav: .none)
}
