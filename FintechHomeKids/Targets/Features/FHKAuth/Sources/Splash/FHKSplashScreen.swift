//
//  FHKSplashScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI
import FHKDesignSystem
import FLibUtils
import FHKTesting
import FHKCore

public struct FHKSplashScreen: View {
    @State private var viewModel: FHKSplashScreenVM
    private var router = NavigationRouter<AuthRoute>()

    public init() {
        self._viewModel = State(initialValue: FHKSplashScreenVM())
    }
    
    public var body: some View {
        
        VStack {
            
        }
    }
}

#Preview("Splash Screen") {
    FHKPreview(setup: {
        FHKPreviewDependencies.registerDefaults()
    }) {
        FHKSplashScreen()
    }
}
