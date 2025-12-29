//
//  Routes.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/12/25.
//

import SwiftUI
import FHKCore
import FHKUtils

// Define each case for a navigation route
public enum Routes: String, NavigationDestination {
    case splash
    case language
    case login
    
    public var hidesNavigationBar: Bool {
        switch self {
        case .splash, .language, .login:
            return true
        default:
            return false
        }
    }
    
    public var id: String {
        return self.rawValue
    }
}


// Define each title by navigation bar
extension Routes {
    
    public var title: String? {
        switch self {
        case .splash:
            return nil
            
        case .language:
            return "language".localized().capitalizingFirstLetter()
            
        case .login:
            return nil
        }
    }
}

// DDefine the respective view for each navigation
extension Routes {
    
    @MainActor @ViewBuilder
    public func view() -> some View {
        switch self {
            
        case .splash:
            SplashScreen()
            
        case .language:
            LanguageScreen()
            
        case .login:
            LoginScreen()
        }
    }
}
