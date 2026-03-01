//
//  SplashModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 3/2/26.
//

import SwiftUI
import FHKUtils
import FHKCore

public struct SplashModel {
    // Properties Screen View
    public let titleApp: String = "title_name_app".localized()
    public let subtitleApp: String = "title_kids".localized()
    
    public enum Navigation: Equatable {
        case goToLanguage
        case goToLogin
    }
    
    private var _splashState: FHKCore.State<Navigation> = .loaded
    var splashState: FHKCore.State<Navigation> {
        get { _splashState }
        set { _splashState = newValue }
    }
}
