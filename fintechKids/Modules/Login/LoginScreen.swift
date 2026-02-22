//
//  LoginScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import SwiftUI
import Lottie
import FHKDesignSystem
import FHKUtils
import FHKCore
import FHKInjections
import FHKObservability

struct LoginScreen<VM: LoginScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    // Properties Injected
    private let toastService = inject.toastService
    private let modalManager = inject.modalManager
    
    var body: some View {
        ScreenContainer {
            switch viewModel.model.loginState {
    
            case .loading:
                LoadingView(msn: viewModel.model.msnLoading)
                
            default:
                FormView
            }
        }
        .onChange(of: viewModel.model.loginState) { _, state in
            switch state {
            case .finish:
                router.navigate(to: .home)
                
            case .error:
                modalManager.show {
                    modalInformationError
                }
                
            default:
                break
            }
        }
        .onAppear {
            viewModel.model.email = "leonfrcol@gmail.com"
            viewModel.model.password = "1234567890"
        }
    }
    
    var FormView: some View {
        ZStack {
            
            VStack(spacing: 20) {
                
                LottieView(animationName: Lotties.login,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: 200)
                
                // Titles
                VStack(spacing: 4) {
                    
                    Text(viewModel.model.wellcome)
                        .font(.PangramSans.bold(FHKSize.size28))
                        .foregroundColor(FHKColor.lunarSand)
                    
                    Text(viewModel.model.startSesionYourAccount)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundColor(FHKColor.lunarSand.opacity(0.6))
                }
                .padding(.bottom, FHKSpace.space20)
                
                // Fields
                VStack(spacing: FHKSpace.space16) {
                    GradientBorderField(text: $viewModel.model.email,
                                        placeholder: viewModel.model.emailPlaceholder)
                    
                    GradientBorderField(text: $viewModel.model.password,
                                        placeholder: viewModel.model.passwordPlaceholder,
                                        isSecure: true)
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
                        Text(viewModel.model.youForgotYourPassword)
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.lunarSand)
                    })
                }
                .padding(.trailing, FHKSpace.space04)
                
                FHKButtonPrimary(title: viewModel.model.startSesion,
                                 state: viewModel.model.isBtnContinueEnable,
                                 mode: .solid,
                                 action: {
                    Task {
                        await viewModel.action(.doLogin)
                    }
                })
                
                Button(action: {
                    router.navigate(to: .register)
                }, label: {
                    HStack {
                        Text(viewModel.model.youNotHaveAccount)
                            .font(.PangramSans.extraboldItalic(FHKSize.size16))
                            .foregroundColor(FHKColor.silver.opacity(0.8))
                        
                        Text(viewModel.model.register)
                            .underline()
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.pastelPink)
                            .padding(.bottom, 2)
                    }
                    .padding(.top, FHKSpace.space16)
                })
                .font(.caption)
                
                Button(action: {
                    toastService.show(
                        info: ToastInfo(type: .notification,
                                        message: "Prueba de notificacion si incluso a doble linea o mas ...",
                                        hasIcon: true),
                        duration: 5.0)
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
            FHKInformationView(title: viewModel.model.titleError,
                               message: viewModel.model.msnError,
                               type: .error,
                               confirmButtonText: viewModel.model.titleBtnError,
                                confirmAction: {
                modalManager.dismiss()
            })
        }
    }
}

#Preview {
    LoginScreen(viewModel: LoginScreenVM())
}
