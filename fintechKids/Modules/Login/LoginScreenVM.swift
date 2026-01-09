//
//  LoginScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import SwiftUI
import Combine
import Supabase
import FHKCore
import FHKAuth
import Observation

@Observable
final class LoginScreenVM: FHKCore.ViewModel {
    private let loginActor: Login
    var model: LoginModel = .init()

    init(loginActor: Login = Login(factory: DefaultAuthServiceFactory())) {
        self.loginActor = loginActor
    }
    
    enum Action: Equatable {
        case doLogin
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .doLogin:
            await fetchLogin()
        }
    }
    
    @MainActor
    func fetchLogin() async {
        model.loginState = .loading
        do {
            try await loginActor.loginUser(platform: .supabase,
                                           email: model.email,
                                           password: model.password)
            model.loginState = .loaded(nil)
        } catch {
            model.loginState = .error(error)
        }
    }
 }
