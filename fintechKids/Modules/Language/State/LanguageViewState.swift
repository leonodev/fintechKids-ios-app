//
//  LanguageModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 6/2/26.
//

import SwiftUI
import FHKUtils
import FHKCore
import FHKDesignSystem

public struct LanguageViewState {
    
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
    
    var selectedFlag: Image = .noneFlag
    
    public let allFlags: [Image] = [
        .spainCircleFlag,
        .italyCircleFlag,
        .englandCircleFlag,
        .franceCircleFlag
    ]
    
    // Properties Accessibility
    public var menuLanguageIdentifier: String = "menu_language"
    
    private var _languageState: FHKCore.State<Never> = .loading
    var languageState: FHKCore.State<Never> {
        get { _languageState }
        set { _languageState = newValue }
    }
}
