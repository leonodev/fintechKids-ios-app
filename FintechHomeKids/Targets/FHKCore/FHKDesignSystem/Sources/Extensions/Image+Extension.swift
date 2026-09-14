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
    static let menuLoansEnable = Image("loan_enable", bundle: .module)
    static let menuLoansDisabled = Image("loan_disable", bundle: .module)
    static let menuPaymentEnable = Image("payment_enable", bundle: .module)
    static let menuPaymentDisabled = Image("payment_disable", bundle: .module)
    static let menuSavingsEnable = Image("savings_enable", bundle: .module)
    static let menuSavingsDisabled = Image("savings_disable", bundle: .module)
    static let menuTransferEnable = Image("transfer_enable", bundle: .module)
    static let menuTransferDisabled = Image("transfer_disable", bundle: .module)
    
    // Images
    static let coinSingle = Image("coin", bundle: .module)
    
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

