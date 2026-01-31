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
    private let loginActor: Login
    var model: RegisterModel = .init()
    
    init(loginActor: Login = Login(factory: DefaultAuthServiceFactory())) {
        self.loginActor = loginActor
    }
    
    enum Action: Equatable {
        case clearInfomember
        case removeMember(member: FamilyMember)
        case registerUser
        case onAppear
    }
    
    @MainActor
    func action(_ action: Action) async {
        switch action {
        case .clearInfomember:
            clearInfomember()
            
        case .removeMember(let member):
            await removeMember(member)
            
        case .registerUser:
            await registerUser()
            
        case .onAppear:
            await onAppear()
        }
    }
    
    func onAppear() async {
       
    }
    
    func clearInfomember() {
        model.clearInfoNewmember()
    }
    
    func removeMember(_ member: FamilyMember) async {
        model.familyMembers.removeAll(where: { $0.id == member.id })
    }
    
    @MainActor
    func registerUser() async {
        model.registerState = .loading
        
        do {
            try await loginActor.registerUser(platform: .supabase,
                                              email: model.emailFamily,
                                              password: model.password)
            model.isRegisterSuccess = true
        } catch let error as AuthDomainError {
            model.setMessageRegisterError(error: error)
            model.registerState = .error(error)
        } catch {
            model.registerState = .error(error)
        }
    }
}
