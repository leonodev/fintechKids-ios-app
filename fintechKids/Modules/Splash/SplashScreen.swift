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
import FHKUtils

struct SplashScreen<VM: SplashScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer {
            /*
             viewModel.destination used in the view
             to detect the change of state
             */
            if viewModel.destination == nil {
                VStack(spacing: 20) {
                    Spacer()
                    
                    GradientText(title: "title_name_app".localized(),
                                 subtitle: "title_kids".localized())
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
                .task {
                    await viewModel.readLanguage()
                }
            }
        }
        .onChange(of: viewModel.destination) { _, destination in
            guard let destination else { return }
            
            switch destination {
            case .login:
                router.navigate(to: .login)
            case .language:
                router.navigate(to: .language)
            }
        }
    }
}

#Preview {
    SplashScreen(viewModel: SplashScreenVM())
}
