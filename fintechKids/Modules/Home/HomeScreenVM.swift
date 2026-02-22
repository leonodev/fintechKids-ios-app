//
//  HomeScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/1/26.
//

import SwiftUI
import Combine
import Supabase
import FHKCore
import FHKAuth
import Observation

@Observable
final class HomeScreenVM: FHKCore.ViewModel {
    var model: HomeModel = .init()
    
    enum Action: Equatable {
        case familyInfo
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .familyInfo:
            await getFamilyInfo()
        }
    }
    
    func getFamilyInfo() async {}
}
