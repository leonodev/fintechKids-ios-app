//
//  FHKLoginScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 4/9/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem

public struct FHKLoginScreen: View {
    @State private var viewModel: FHKLoginScreenVM
    @Router private var router: NavigationRouter<AuthRoute>
    
    public init() {
        self._viewModel = State(initialValue: FHKLoginScreenVM())
    }
    
    public var body: some View {
        
        FHKScreenContainer(title: AuthRoute.login.title) {
            switch viewModel.viewState.loginState {
    
            case .loading:
                loadingView
              
            case .finish, .loaded:
                loadedView
            }
        }
        .observeLanguage()
        .onChange(of: viewModel.viewState.loginState) { _, state in
            switch state {
            case .finish(let result):
                
                switch result {
                case .success:
                    //router.navigate(to: .home)
                    print("navigation to home")
                    
                case .error:
                    viewModel.fhkModal.show(
                        onDismiss: {
                            print("El usuario cerró el modal")
                        }, content: {
                            modalInformationError
                        }
                    )
                }

            default:
                break
            }
        }
//        .onAppear {
//            viewModel.viewState.email = "leonfrcol@gmail.com"
//            viewModel.viewState.password = "1234567890"
//        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ZStack {
            
            VStack(spacing: 20) {
                
                LottieView(animationName: Lotties.login,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: 200)
                
                // Titles
                VStack(spacing: 4) {
                    
                    Text(viewModel.viewState.wellcome)
                        .font(.PangramSans.bold(FHKSize.size28))
                        .foregroundColor(FHKColor.lunarSand)
                    
                    Text(viewModel.viewState.startSesionYourAccount)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundColor(FHKColor.lunarSand.opacity(0.6))
                }
                .padding(.bottom, FHKSpace.space20)
                
                // Fields
                VStack(spacing: FHKSpace.space16) {
                    FHKTextField(text: $viewModel.viewState.email,
                                 placeholder: viewModel.viewState.emailPlaceholder,
                                 identifier: "tfd_email_user_id"
                    )
                    
                    FHKTextField(text: $viewModel.viewState.password,
                                 placeholder: viewModel.viewState.passwordPlaceholder,
                                 isSecure: true,
                                 identifier: "tfd_password_user_id"
                    )
                }
                
                // We only show the Face ID button if a previous token exists.
                if  viewModel.isBiometryAvailable && viewModel.hasSavedAuthToken {
                    Button(action: {
                        Task { await viewModel.action(.doLoginWithBiometrics) }
                    }, label: {
                        Image(systemName: viewModel.biometryIconName)
                            .resizable()
                            .frame(width: FHKSize.size44, height: FHKSize.size44)
                            .foregroundStyle(FHKColor.basicWhite)
                    })
                    .padding(.vertical, FHKSpace.space08)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        // Action to recover password
                    }, label: {
                        Text(viewModel.viewState.youForgotYourPassword)
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.lunarSand)
                    })
                }
                .padding(.trailing, FHKSpace.space04)
                
                FHKButtonPrimary(title: viewModel.viewState.startSesion,
                                 state: viewModel.viewState.isBtnContinueEnable,
                                 mode: .solid,
                                 identifier: "btn_login_start_sesion_id",
                                 action: {
                    Task {
                        await viewModel.action(.doLogin)
                    }
                })
                
                Button(action: {
                    router.navigate(to: .register)
                }, label: {
                    HStack {
                        Text(viewModel.viewState.youNotHaveAccount)
                            .font(.PangramSans.extraboldItalic(FHKSize.size16))
                            .foregroundColor(FHKColor.silver.opacity(0.8))
                        
                        Text(viewModel.viewState.register)
                            .underline()
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.pastelPink)
                            .padding(.bottom, 2)
                    }
                    .padding(.top, FHKSpace.space16)
                })
                .font(.caption)
                
                Button(action: {
                    let info = FHKToastInfo(type: .notification,
                                            message: "Prueba de notificacion si incluso a doble linea o mas ...",
                                            hasIcon: true)
                    Task {
                        await viewModel.action(.showInfo(info: info))
                    }
                },
                label: {
                    Text("Mostrar Notificacion")
                })
            }
            .padding(FHKSpace.space28)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.15))
                    .shadow(radius: 20)
            )
            .padding(.horizontal, FHKSpace.space28)
            .shadow(radius: 20)
        }
        .padding(.bottom, FHKSpace.space28)
    }
    
    var modalInformationError: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnLoginFail,
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleBtnUnderstood,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
            })
        }
        .accessibilityIdentifier("error_modal_login_id")
    }
}


// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview(setup: {
        FHKPreviewDependencies.registerDefaults()
    }) {
        FHKLoginScreen()
        .environment(NavigationRouter<AuthRoute>())
    }
}
