//
//  RegisterScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import Combine
import Supabase
import FHKCore
import FHKAuth
import Observation

@Observable
final class RegisterScreenVM: FHKCore.ViewModel {
    var model: RegisterModel = .init()
    
    enum Action: Equatable {
        case onAppear
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .onAppear:
            await onAppear()
        }
    }
    
    func onAppear() async {
        
    }
}
