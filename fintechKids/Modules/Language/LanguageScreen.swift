//
//  LanguageScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKUtils
import FHKCore
import FHKDesignSystem

struct LanguageScreen<VM: LanguageScreenVM>: View {
    private let flagAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.15)
    
    @NavigationRouterWrapper<Routes> private var router
    @State var viewModel: VM
    @Namespace var nameSpaceMenu
    @State private var isExpanded = false
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.language) {
            switch viewModel.viewState.languageState {
            
            case .loaded:
                loadedView
                
            case .loading:
                loadingView
            }
        }
        .onAppear {
            Task {
                await viewModel.action(.loadRemoteConfig)
                await viewModel.action(.sendAnalitycOpenScreen)
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
}

// MARK: config view language
extension LanguageScreen {
    
    private var loadedView: some View {
        ZStack {
            LottieView(animationName: Lotties.language,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit)
            .accessibilityHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                HStack(alignment: .top) {
                    EnvironmentView()
                        .padding(.top, FHKSize.size08)
                    
                    Spacer()
                    
                    HStack {
                        Text(viewModel.viewState.selectLanguageNow)
                            .foregroundStyle(FHKColor.basicWhite)
                            .multilineTextAlignment(.center)
                            .font(.PangramSans.bold(FHKSize.size28))
                            .padding(.top, FHKSize.size44)
                            .accessibilityIdentifier("select_language_title_id")
                    }
                    
                    Spacer()
                    
                    VStack {
                        menuLanguageView
                        Spacer()
                    }
                    .frame(width: FHKSize.size60)
                }
                .padding(.trailing, FHKSize.size08)
                
                FHKButtonPrimary(title: viewModel.viewState.continueButtom,
                                 state: .enabled,
                                 mode: .solid,
                                 identifier: "btn_language_continue_id",
                                 action: {
                    router.navigate(to: .login)
                })
                .padding()
                
                Text(viewModel.viewState.version)
                    .accessibilityLabel(viewModel.viewState.version)
                    .foregroundStyle(FHKColor.basicWhite)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var menuOptions: [Image] {
        // Exclude the currently selected flag from the menu
        viewModel.viewState.allFlags.filter { flag in
            // Get the language code from the flag name (ES, IT, EN, FR)"
            let code = flag.imageToCode
            
            // Only include the flag if its code is in the Remote Config list and it is not the selected flag"
            return viewModel.languages.contains(code) && flag != viewModel.viewState.selectedFlag
        }
    }
    
    var menuLanguageView: some View {
        HStack {
            Spacer()
    
            VStack(alignment: .trailing) {
                menuClosedView
                if isExpanded {
                    menuOpenedView
                }
            }
            .padding(.all, FHKSize.size12)
            .padding(.trailing, FHKSize.size12)
        }
    }
    
    var menuClosedView: some View {
        viewModel.viewState.selectedFlag
            .resizable()
            .accessibilityIdentifier("menu_selected_language_id")
            .accessibilityLabel("Idioma actual: \(viewModel.viewState.selectedFlag.imageToCode)")
            .accessibilityHint("Toca para cambiar el idioma")
            .accessibilityAddTraits(.isButton) // Indica que es interactivo
            .frame(width: FHKSize.size52, height: FHKSize.size52)
            .onTapGesture {
                withAnimation(flagAnimation) {
                    isExpanded = true
                }
            }
    }
    
    var menuOpenedView: some View {
        Group {
            ForEach(Array(menuOptions.enumerated()), id: \.offset) { _, img in
                img
                    .resizable()
                    .accessibilityLabel("Cambiar a \(img.imageToCode)")
                    .accessibilityAddTraits(.isButton)
                    .frame(width: FHKSize.size48, height: FHKSize.size48)
                    .onTapGesture {
                        withAnimation(flagAnimation) {
                            viewModel.viewState.selectedFlag = img
                            
                            Task {
                                let codeLanguage = img.imageToCode
                                let btnAnatilycs = viewModel.getBtnLanguage(code: codeLanguage)

                                await viewModel.action(.changeImageFlag(codeLanguage))
                                await viewModel.action(.changeLanguageApp(codeLanguage))
                                await viewModel.action(.sendAnalitycSelectLanguage(btn: btnAnatilycs))
                            }
                            isExpanded = false
                        }
                    }
                    .accessibilityIdentifier("option_language_id")
            }
        }
    }
}

#Preview {
    LanguageScreen(viewModel: LanguageScreenVM())
}
