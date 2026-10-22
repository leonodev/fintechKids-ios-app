//
//  Image+Extension.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

import SwiftUI
import FHKCore

public extension Image {
    static let background = Image("bg", bundle: .module)
    static let background2 = Image("bg2", bundle: .module)
    static let backgroundDemo = Image("bg_demo", bundle: .module)
    
    // Flags
    static let noneFlag = Image("worldwide-circle", bundle: .module)
    static let englandCircleFlag = Image("england-circle", bundle: .module)
    static let franceCircleFlag = Image("france-circle", bundle: .module)
    static let italyCircleFlag = Image("italy-circle", bundle: .module)
    static let spainCircleFlag = Image("spain-circle", bundle: .module)
    
    // Icons
    static let fintechkidsTime = Image("fintechkids_time", bundle: .module)
    static let fintechkidsCoins = Image("fintechkids_coins", bundle: .module)
    
    // Menus

    static let paidEnable = Image("paid_enable", bundle: .module)
    static let paidDisable = Image("paid_disable", bundle: .module)
    
    static let loansEnable = Image("loans_enable", bundle: .module)
    static let loansDisabled = Image("loans_disable", bundle: .module)
    
    static let savingsEnable = Image("savings_enable", bundle: .module)
    static let savingsDisabled = Image("savings_disable", bundle: .module)
    
    
    // Images
    static let coinSingle = Image("coin", bundle: .module)
    static let clock = Image("clock", bundle: .module)
    
    static let loansMemberEnable = Image("loans_member_enable", bundle: .module)
    static let loansMemberDisable = Image("loans_member_disable", bundle: .module)
    
    static let transferMemberEnable = Image("transfer_member_enable", bundle: .module)
    static let transferMemberDisable = Image("transfer_member_disable", bundle: .module)
    
    static let expansiveMemberEnable = Image("expansive_member_enable", bundle: .module)
    static let expansiveMemberDisable = Image("expansive_member_disable", bundle: .module)
    
    static let movementsMemberEnable = Image("movements_member_enable", bundle: .module)
    static let movementsMemberDisable = Image("movements_member_disable", bundle: .module)
    
    
    
    
    static let headerDetail = Image("header_detail", bundle: .module)
}

extension Image {
    public var imageToCode: String {
        switch self {
        case .englandCircleFlag: return LanguageType.en.code
        case .franceCircleFlag: return LanguageType.fr.code
        case .italyCircleFlag: return LanguageType.it.code
        case .spainCircleFlag: return LanguageType.es.code
        default: return ""
        }
    }
}

