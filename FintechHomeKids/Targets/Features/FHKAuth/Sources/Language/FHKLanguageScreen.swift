//
//  FHKLanguageScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 30/8/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem

public struct FHKLanguageScreen: View {
    @State private var viewModel: FHKLanguageScreenVM
    @Router private var router: NavigationRouter<AuthRoute>
    
    @Namespace var nameSpaceMenu
    @State private var isExpanded = false
    
    private let flagAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.15)

    public init() {
        self._viewModel = State(initialValue: FHKLanguageScreenVM())
    }
    
    public var body: some View {
        
        FHKScreenContainer(title: AuthRoute.language.title) {
            switch viewModel.viewState.languageState {
            
            case .loaded:
                loadedView
                
            case .loading:
                loadingView
            }
        }
        .observeLanguage()
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
extension FHKLanguageScreen {
    
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

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview(setup: {
        FHKPreviewDependencies.registerDefaults()
    }) {
        FHKLanguageScreen()
        .environment(NavigationRouter<AuthRoute>())
    }
}

