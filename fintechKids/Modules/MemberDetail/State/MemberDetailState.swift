//
//  MemberDetailState.swift
//  fintechKids
//
//  Created by Fredy Leon on 9/3/26.
//

import SwiftUI
import FHKUtils
import FHKDesignSystem
import FHKDomain

public struct MemberDetailState {
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: ActionResult)
    }
    
    public var memberState: State = .loading
    
    public var balance: BalanceEntity?
    public var msnUserError: String = ""
    
    public var msnLoading: String {
        "loading".localized().capitalizingFirstLetter()
    }
}
