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
    @Router private var router: NavigationRouter<RoutesDestination>
    @State private var isLanguageSelected = false
    
    private let flagAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.15)

    public init() {
        self._viewModel = State(initialValue: FHKLanguageScreenVM())
    }
    
    public var body: some View {
        FHKScreenContainer(
            headerContent: {
                Text(viewModel.viewState.language)
            },
            content: {
                switch viewModel.viewState.languageState {
                    
                case .loaded:
                    loadedView
                    
                case .loading:
                    loadingView
                }
            }
        )
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
        VStack {
            // view title
            HStack(alignment: .top) {
                EnvironmentView()
                    .padding(.top, FHKSize.size08)
                
                Spacer()
                
                HStack {
                    Text(viewModel.viewState.selectLanguageNow)
                        .foregroundStyle(FHKColor.indigo)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size24))
                        .padding(.top, FHKSize.size44)
                        .accessibilityIdentifier("select_language_title_id")
                }
                
                Spacer()
            }
            
            // view flags
            HStack(spacing: FHKSpace.space16) {
                ForEach(Array(menuOptions.enumerated()), id: \.offset) { _, img in
                    languageItemView(for: img)
                }
            }
            
            // view banner
            LottieView(animationName: Lotties.language,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit)
            .accessibilityHidden(true)
            .frame(maxWidth: 300, maxHeight: 300)
            
            Spacer()
            
            // View Bottons
            FHKButtonPrimary(title: viewModel.viewState.continueButtom,
                             state: isLanguageSelected ? .enabled : .disabled,
                             mode: .solid,
                             identifier: "btn_language_continue_id",
                             action: {
                // set language selected
                setNewLanguage()
                
                // send analytic by language
                sendAnalytics()
                
                // navigate to login screen
                router.navigate(to: .login)
            })
            .padding()
            
            // View Version
            Text(viewModel.viewState.version.capitalizingFirstLetter())
                .accessibilityLabel(viewModel.viewState.version)
                .foregroundStyle(FHKColor.indigo)
                .font(.PangramSans.bold(FHKSize.size20))
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func setNewLanguage() {
        Task {
            let selectedCode = viewModel.viewState.selectedFlag.imageToCode
            await viewModel.action(.changeLanguageApp(selectedCode))
        }
    }
    
    private func sendAnalytics() {
        Task {
            let selectedCode = viewModel.viewState.selectedFlag.imageToCode
            let btnAnatilycs = viewModel.getBtnLanguage(code: selectedCode)
            await viewModel.action(.sendAnalitycSelectLanguage(btn: btnAnatilycs))
        }
    }
    
    private var menuOptions: [Image] {
        // Exclude the currently selected flag from the menu
        viewModel.viewState.allFlags.filter { flag in
            // Get the language code from the flag name (ES, IT, EN, FR)"
            let code = flag.imageToCode
            
            return viewModel.languages.contains(code)
        }
    }
}

// MARK: config view language
extension FHKLanguageScreen {
    
    @ViewBuilder
    private func languageItemView(for img: Image) -> some View {
        let languageCode = img.imageToCode
        let selectedCode = viewModel.viewState.selectedFlag.imageToCode
        let isSelected = (languageCode == selectedCode)
        
        img
            .resizable()
            .accessibilityIdentifier("option_language_id")
            .accessibilityLabel("Cambiar a \(languageCode)")
            .accessibilityHint("Toca para seleccionar este idioma")
            .accessibilityAddTraits(.isButton)
            .frame(width: FHKSize.size52, height: FHKSize.size52)
            .background(
                RoundedRectangle(cornerRadius: FHKSize.size12)
                    .fill(isSelected ? FHKColor.indigo.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: FHKSize.size28)
                    .stroke(isSelected ? FHKColor.wine.opacity(0.7) : Color.clear, lineWidth: 4)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(flagAnimation) {
                    viewModel.viewState.selectedFlag = img
                    isLanguageSelected = true
                    
                    Task {
                        let btnAnatilycs = viewModel.getBtnLanguage(code: languageCode)

                        await viewModel.action(.changeImageFlag(languageCode))
//                        await viewModel.action(.changeLanguageApp(languageCode))
//                        await viewModel.action(.sendAnalitycSelectLanguage(btn: btnAnatilycs))
                    }
                }
            }
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKLanguageScreen()
            .withPreviewRouter()
    }
}

