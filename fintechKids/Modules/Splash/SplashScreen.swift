//
//  SplashScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 19/12/25.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKUtils

struct SplashScreen<VM: SplashScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer {
            switch viewModel.viewState.splashState {
            default:
                infoSplashVew
            }
        }
        .onChange(of: viewModel.viewState.splashState) { _, state in
            switch state {
            case .finish(.goToLogin):
                router.navigate(to: .login)
                
            case .finish(.goToLanguage):
                router.navigate(to: .language)
                
            default:
                break
            }
        }
    }
    
    var infoSplashVew: some View {
        VStack(spacing: 20) {
            Spacer()
            
            GradientText(title: viewModel.viewState.titleApp,
                         subtitle: viewModel.viewState.subtitleApp)
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
        .onAppear {
            Task {
                await viewModel.action(.readLanguageCurrent)
            }
        }
    }
}

#Preview {
    SplashScreen(viewModel: SplashScreenVM())
}
