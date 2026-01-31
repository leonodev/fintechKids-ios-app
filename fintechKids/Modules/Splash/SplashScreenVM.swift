//
//  SplashScreenVM.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import Foundation
import SwiftUI
import Combine
import Observation
import FHKCore
import FHKConfig
import FHKStorage
import FHKUtils

@Observable
final class SplashScreenVM {
    enum NavigationDestination {
        case login
        case language
    }
    
    private let storage: UserDefaultsProtocol
    var languageApp: String?
    /*
     When using destination within @Observable, it is necessary to use
     this property within the Screen so that the property propagates
     its new value to the view
     */
    var destination: NavigationDestination?
    
    public init(storage: UserDefaultsProtocol = UserDefaultStorage()) {
        self.storage = storage   
    }
    
    @MainActor
    public func readLanguage() async {
        guard destination == nil else { return }
        
        let language = try? await storage.read(String.self, forKey: UserDefaultsKeys.languageKey)
        if language != nil {
            destination = .login
        } else {
            destination = .language
        }
    }
}
