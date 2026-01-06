//
//  LanguageScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 10/11/25.
//

import SwiftUI
import FHKUtils
import FHKCore
import FHKConfig
import FHKDesignSystem

struct LanguageScreen: View {
    private let flagAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.15)
    
    @NavigationRouterWrapper<Routes> private var router
    @StateObject private var viewModel = LanguageViewModel(configManager: RemoteConfigManager())
    @Namespace var nameSpaceMenu
    @State private var isExpanded = false

    var body: some View {
        ScreenContainer {
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
                            Text("select_language_now".localized().capitalizingFirstLetter())
                                .multilineTextAlignment(.center)
                                .font(.PangramSans.bold(FHKSize.size28))
                                .padding(.top, FHKSize.size44)
                        }
                        
                        Spacer()
                        
                        VStack {
                            menuLanguageView
                                .accessibilityIdentifier("menu_language")
                            Spacer()
                        }
                        .frame(width: FHKSize.size60)
                    }
                    .padding(.trailing, FHKSize.size08)
                    
                    FHKButtonPrimary(title: "continue".localized().capitalizingFirstLetter(),
                                     state: .enabled,
                                     mode: .solid,
                                     action: {
                        router.navigate(to: .login)
                    })
                    .padding()
                    
                    Text("version".localized())
                        .accessibilityLabel("Versión de la aplicación: \(Text("version".localized()))")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .onAppear {
                viewModel.loadConfig()
            }
            .onChange(of: viewModel.initialLanguageCode) { _, newCode in
                let languageType = Configuration.languageTypeFromCode(newCode)
                self.viewModel.selectedFlag = languageType.languageTypeToImageFlag
                Task {
                    await viewModel.saveLanguage(newCode)
                }
            }
        }
    }
}


#Preview {
    LanguageScreen()
}

// MARK: config view language
extension LanguageScreen {
    
    private var menuOptions: [Image] {
        // Exclude the currently selected flag from the menu
        return viewModel.allFlags.filter { flag in
            // Get the language code from the flag name (ES, IT, EN, FR)"
            let code = flag.imageToCode
            
            // Only include the flag if its code is in the Remote Config list and it is not the selected flag"
            return viewModel.languages.contains(code) && flag != viewModel.selectedFlag
        }
    }
    
    var menuLanguageView: some View {
        HStack {
            Spacer()
            
            GlassEffectContainer {
                VStack(alignment: .trailing) {
                    menuClosedView
                    if isExpanded {
                        menuOpenedView
                    }
                }
                .padding()
            }
            .padding(.top, FHKSize.size12)
            .padding(.trailing, FHKSize.size12)
        }
    }
    
    var menuClosedView: some View {
        viewModel.selectedFlag
            .resizable()
            .accessibilityLabel("Idioma actual: \(viewModel.selectedFlag.imageToCode)")
            .accessibilityHint("Toca para cambiar el idioma")
            .accessibilityAddTraits(.isButton) // Indica que es interactivo
            .frame(width: FHKSize.size52, height: FHKSize.size52)
            .onTapGesture {
                withAnimation(flagAnimation) {
                    isExpanded.toggle()
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
                            viewModel.selectedFlag = img
                            
                            Task {
                                let codeLanguage = img.imageToCode
                                await viewModel.saveLanguage(codeLanguage.lowercased())
                            }
                            isExpanded = false
                        }
                    }
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                 removal: .move(edge: .top).combined(with: .opacity)))
        .glassEffect()
        .glassEffectUnion(id: 1, namespace: nameSpaceMenu)
        .glassEffectTransition(.matchedGeometry)
    }
}
