//
//  AuthRoute.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/8/26.
//

import SwiftUI
import FHKCore

public enum AuthRoute: NavigationDestination {
    case language
    case login
    case register
    
    public var title: String? {
        switch self {
        case .login:
            return "login".localized().capitalizingFirstLetter()
            
        case .register:
            return "register".localized().capitalizingFirstLetter()
            
        case .language:
            return "language".localized().capitalizingFirstLetter()
        }
    }
    
    public var hidesNavigationBar: Bool {
        switch self {
        case .login:
            return true
            
        default:
            return false
        }
    }
    
    @MainActor @ViewBuilder
    public func view() -> some View {
        switch self {
            
        case .login:
            EmptyView()
            //FHKLoginScreen()
            
        case .language:
            EmptyView()
            //FHKLanguageScreen()
            
        default:
            EmptyView()
        }
    }
}
