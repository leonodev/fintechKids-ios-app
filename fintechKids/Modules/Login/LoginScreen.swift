//
//  LoginScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 11/12/25.
//

import SwiftUI
import Lottie
import FHKDesignSystem
import FHKCore
import FHKUtils

struct LoginScreen<VM: LoginScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer {
            switch viewModel.viewState.loginState {
    
            case .loading:
                loadingView
                
            default:
                FormView
            }
        }
        .onChange(of: viewModel.viewState.loginState) { _, state in
            switch state {
            case .finish:
                router.navigate(to: .home)
                
            case .error:
                viewModel.modalManager.show {
                    modalInformationError
                }
                
            default:
                break
            }
        }
        .onAppear {
            viewModel.viewState.email = "leonfrcol@gmail.com"
            viewModel.viewState.password = "1234567890"
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
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
                    GradientBorderField(text: $viewModel.viewState.email,
                                        placeholder: viewModel.viewState.emailPlaceholder)
                    
                    GradientBorderField(text: $viewModel.viewState.password,
                                        placeholder: viewModel.viewState.passwordPlaceholder,
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
                        Text(viewModel.viewState.youForgotYourPassword)
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.lunarSand)
                    })
                }
                .padding(.trailing, FHKSpace.space04)
                
                FHKButtonPrimary(title: viewModel.viewState.startSesion,
                                 state: viewModel.viewState.isBtnContinueEnable,
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
                    viewModel.toastService.show(
                        info: FHKToastInfo(type: .notification,
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
            FHKInformationView(title: viewModel.viewState.titleError,
                               message: viewModel.viewState.msnError,
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleBtnError,
                                confirmAction: {
                viewModel.modalManager.dismiss()
            })
        }
    }
}

#Preview {
    LoginScreen(viewModel: LoginScreenVM())
}
