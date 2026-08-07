//
//  Images.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 25/11/25.
//

import SwiftUI

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
    static let menuLoansEnable = Image("loan_gold", bundle: .module)
    static let menuLoansDisabled = Image("loan_gray", bundle: .module)
    static let menuPaymentEnable = Image("payment_gold", bundle: .module)
    static let menuPaymentDisabled = Image("payment_gray", bundle: .module)
    static let menuSavingsEnable = Image("savings_gold", bundle: .module)
    static let menuSavingsDisabled = Image("savings_gray", bundle: .module)
    static let menuTransferEnable = Image("transfer_gold", bundle: .module)
    static let menuTransferDisabled = Image("transfer_gray", bundle: .module)
    
    // Images
    static let coinSingle = Image("coin", bundle: .module)
}
