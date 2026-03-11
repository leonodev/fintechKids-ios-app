//
//  MemberDetailScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 9/3/26.
//

import Observation
import FHKCore
import FHKInjections
import FHKDomain
import FHKFirebase
import FHKUtils

@Observable
final class MemberDetailScreenVM: FHKCore.ViewModel {
    var viewState: MemberDetailState = .init()
    
    public enum Action: Equatable {
        case test
    }
    
    @MainActor
    public func action(_ action: Action) async {
        switch action {
            
        case .test:
            break
        }
    }
}
