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
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.splashState) { _, state in
            switch state {
            case .loaded(nav: .goToLogin):
                router.navigate(to: .login)
                
            case .loaded(nav: .goToLanguage):
                router.navigate(to: .language)
                
            case .loaded(nav: .none):
                break
            }
        }
    }
    
    var loadedView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            GradientText(title: viewModel.viewState.titleApp,
                         subtitle: viewModel.viewState.subtitleApp)
            .padding(.vertical, FHKSize.size20)
            
            Spacer()
            
            LottieView(animationName: Lotties.operationsBoard,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit,
            identifier: "lottie_operations_board_id")
            
            Spacer()
            
            LottieView(animationName: Lotties.progressBar,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit,
            identifier: "lottie_progress_bar_id")
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
