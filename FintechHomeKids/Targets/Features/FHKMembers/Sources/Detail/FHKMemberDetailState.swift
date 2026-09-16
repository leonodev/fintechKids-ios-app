//
//  FHKMemberDetailState.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 15/9/26.
//


import SwiftUI
import FLibUtils
import FHKDesignSystem
import FHKDomain
import FHKCore

@MainActor
public struct FHKMemberDetailState {
    public var member: FHKMemberEntity? = nil
    
    public enum State: Equatable {
        case loading
        case loaded
        case finish(result: FHKActionResult)
    }
    
    public var memberState: State = .loading
    
    public var balance: FHKBalanceEntity?
    public var msnUserError: String = ""
    
    public var msnLoading: String {
        "loading".localized.capitalizingFirstLetter()
    }
}
