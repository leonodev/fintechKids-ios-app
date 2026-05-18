//
//  ProfileViewState.swift
//  fintechKids
//
//  Created by Fredy Leon on 8/3/26.
//

import SwiftUI
import FHKUtils
import FHKDesignSystem
import FHKDomain

public struct ProfileViewState {
    
    let languages = [
        (name: LanguageType.es.name, code: LanguageType.es.code, img: Image.spainCircleFlag),
        (name: LanguageType.en.name, code: LanguageType.en.code, img: Image.englandCircleFlag),
        (name: LanguageType.fr.name, code: LanguageType.fr.code, img: Image.franceCircleFlag),
        (name: LanguageType.it.name, code: LanguageType.it.code, img: Image.italyCircleFlag)
    ]
    
    // msn loading
    public var msnLoading: String {
        "msn_close_sesion_loading".localized().capitalizingFirstLetter()
    }
    
    public var titleFamily: String {
        "title_family".localized().capitalizingFirstLetter()
    }
    
    public var titleBtnModal: String {
        "continue".localized().uppercased()
    }
    
    public var titleSettingLanguages: String {
        "title_setting_languages".localized().uppercased()
    }
    
    public var isBtnSaveChangesEnable: FHKButtonComponent.State {
        .enabled
    }
    
    public var titleCloseSession: String {
        "title_close_session".localized().uppercased()
    }
    
    public var msnCloseSession: String {
        "msn_close_sesion".localized().capitalizingFirstLetter()
    }
    
    public var btnCancel: String {
        "cancel".localized().uppercased()
    }
    
    public var btnContinue: String {
        "continue".localized().uppercased()
    }
    
    public var msnLogoutResult: String = ""

    // States screen
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
        case confirmation
    }
    
    public var profileState: State = .loaded
}
