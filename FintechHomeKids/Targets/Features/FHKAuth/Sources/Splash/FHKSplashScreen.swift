//
//  FHKSplashScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 25/8/26.
//

import SwiftUI
import FHKDesignSystem
import FLibUtils
import FHKCore

public struct FHKSplashScreen: View {
    @State private var viewModel: FHKSplashScreenVM
    @Router private var router: NavigationRouter<AuthRoute>

    public init() {
        self._viewModel = State(initialValue: FHKSplashScreenVM())
    }
    
    public var body: some View {
        
        FHKScreenContainer {
            switch viewModel.viewState.splashState {
                 
            default:
                loadedView
            }
        }
        .observeLanguage()
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

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview(setup: {
        FHKPreviewDependencies.registerDefaults()
    }) {
        FHKSplashScreen()
            .environment(NavigationRouter<AuthRoute>())
    }
}

// Para probar el flujo de navegación y la interacción real
#Preview("Navigation / Full Flow") {
    FHKPreview(setup: {
        FHKPreviewDependencies.registerDefaults()
    }) {
        NavigationContainer(router: NavigationRouter<AuthRoute>()) {
            FHKSplashScreen()
        }
    }
}
