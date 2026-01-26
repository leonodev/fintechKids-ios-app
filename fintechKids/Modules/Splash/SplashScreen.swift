//
//  SplashScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/12/25.
//

import SwiftUI
import FHKCore
import FHKConfig
import FHKDesignSystem

struct SplashScreen: View {
    @NavigationRouterWrapper<Routes> private var router
    @StateObject var viewModel: SplashScreenVM = SplashScreenVM()
    
    var body: some View {
        ScreenContainer {
            VStack(spacing: 20) {
                Spacer()
                
                GradientText(title: "FintechHome", subtitle: "Kids")
                    .padding(.vertical, FHKSize.size20)
                
                Spacer()
                
                LottieView(animationName: Lotties.operationsBoard,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                
                Spacer()
                
                LottieView(animationName: Lotties.progressBar,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
            }
            .onChange(of: viewModel.isConfigLanguageReady) { _, _ in
                guard viewModel.languageApp != nil else {
                    router.navigate(to: .language)
                    return
                }
                router.navigate(to: .login)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
