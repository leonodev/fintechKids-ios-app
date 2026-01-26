//
//  RegisterModel.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI
import Combine
import Observation
import FHKAuth
import FHKUtils
import FHKCore
import FHKDesignSystem

@Observable
public class RegisterModel {
    public var familyName = ""
    public var titleFamilyName = ""
    public var familyNamePlaceholder = ""
    
    public var emailFamily = ""
    public var titleEmailFamily = ""
    public var emailFamilyPlaceholder = ""
    
    public var titlePassword = ""
    public var passwordPlaceholder = ""
    public var password = ""
    
    public var titleRegisterBtn = ""
    
    public let avatarIList = AvatarType.allCases
    
    init() {
        titleFamilyName = "family_name".localized().capitalizingFirstLetter()
        familyNamePlaceholder = "family_name".localized().capitalizingFirstLetter()
        
        emailFamily = "email".localized().capitalizingFirstLetter()
        titleEmailFamily = "email".localized().capitalizingFirstLetter()
        emailFamilyPlaceholder = "email".localized().capitalizingFirstLetter()
        
        titlePassword = "password".localized().capitalizingFirstLetter()
        passwordPlaceholder = "password".localized().capitalizingFirstLetter()
        password = "password".localized().capitalizingFirstLetter()
        
        titleRegisterBtn = "register".localized().uppercased()
    }
}


