//
//  FHKForgotScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 21/11/2026.
//

import SwiftUI
import FHKCore
import FHKDesignSystem

public struct FHKForgotScreen: View {
    @State private var viewModel: FHKForgotScreenVM
    @Router private var router: NavigationRouter<RoutesDestination>
    
    public init() {
        self._viewModel = State(initialValue: FHKForgotScreenVM())
    }
    
    public var body: some View {
        FHKScreenContainer(
            headerContent: {
                Text(viewModel.viewState.titleRecoveryPassword)
            },
            content: {
                switch viewModel.viewState.forgotState {
                    
                case .loading:
                    loadingView
                    
                case .loaded(.requestCode):
                    requestCodeView
                    
                case .loaded(.resetPassword):
                    resetPasswordView
                    
                case .finish:
                    resetPasswordSuccess
                    
                case .error:
                    errorView
                }
            }
        )
        .observeLanguage() 
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var requestCodeView: some View {
        VStack(spacing: 20) {
            LottieView(animationName: Lotties.forgotPassword,
                       loopMode: .loop,
                       contentMode: .scaleAspectFit)
            .frame(height: 200)
            
            Text(viewModel.viewState.msnRecoveryPassword)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.indigo)
            
            
            FHKTextField(text: $viewModel.viewState.email,
                         placeholder: viewModel.viewState.emailPlaceholder,
                         identifier: "tfd_email_user_id"
            )
            .padding()
            .onAppear {
                viewModel.viewState.email = "leonfrcol@gmail.com"
            }
            
            Spacer()
            
            FHKButtonPrimary(title: viewModel.viewState.titleRequestCode,
                             state: viewModel.viewState.isBtnContinueEnable,
                             mode: .solid,
                             identifier: "btn_request_code_id",
                             action: {
                Task {
                    await viewModel.action(.forgotPassword)
                }
            })
            .padding()
        }
        .padding()
    }
    
    var resetPasswordView: some View {
        ScrollView {
            VStack(spacing: 20) {
                LottieView(animationName: Lotties.forgotPassword,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: 150)
                
                if let codeDebug = viewModel.viewState.debugRecoveryCode {
                    Text(codeDebug)
                        .font(.PangramSans.bold(FHKSize.size36))
                        .foregroundColor(FHKColor.indigo)
                        .padding(.top, FHKSpace.space32)
                }
     
                Text(viewModel.viewState.msnRequestCodeForgotSuccess)
                    .font(.PangramSans.semibold(FHKSize.size20))
                    .foregroundColor(FHKColor.indigo)
                    .padding(.horizontal, FHKSpace.space24)
                
                FHKTextField(text: $viewModel.viewState.code,
                             placeholder: viewModel.viewState.titleResetCode,
                             identifier: "tfd_reset_password_code_id"
                )
                .padding(.horizontal)
                .onAppear {
                    viewModel.viewState.code = "0000"
                }
                
                FHKTextField(text: $viewModel.viewState.newPassword,
                             placeholder: viewModel.viewState.passwordPlaceholder,
                             isSecure: true,
                             identifier: "tfd_new_password_id"
                )
                .padding(.horizontal)
                .onAppear {
                    viewModel.viewState.newPassword = "12312312"
                }
                
                FHKTextField(text: $viewModel.viewState.confirmPassword,
                             placeholder: viewModel.viewState.confirmPasswordPlaceholder,
                             isSecure: true,
                             identifier: "tfd_confirm_password_id"
                )
                .padding(.horizontal)
                .onAppear {
                    viewModel.viewState.confirmPassword = "12312312"
                }
                
                Spacer()
                
                FHKButtonPrimary(title: viewModel.viewState.titleResetPassword,
                                 state: viewModel.viewState.isBtnResetContinueEnable,
                                 mode: .solid,
                                 identifier: "btn_reset_code_id",
                                 action: {
                    Task {
                        await viewModel.action(.resetPassword)
                    }
                })
                .padding()
            }
        }
       
    }
    
    var resetPasswordSuccess: some View {
        VStack(spacing: 20) {
            LottieView(animationName: Lotties.checkSuccess,
                       loopMode: .playOnce,
                       contentMode: .scaleAspectFit)
            .frame(height: 150)
            
            Text(viewModel.viewState.msnResetPasswordFinishSuccess)
                .font(.PangramSans.semibold(FHKSize.size20))
                .foregroundColor(FHKColor.indigo)
                .padding(.horizontal, FHKSpace.space24)
            
            Spacer()
            
            FHKButtonPrimary(title: viewModel.viewState.titleContinue,
                             state: .enabled,
                             mode: .solid,
                             identifier: "btn_reset_continue_id",
                             action: {
                Task {
                    router.pop()
                }
            })
            .padding()
        }
    }
    
    var errorView: some View {
        ErrorView(title: viewModel.viewState.titleBtnErrorSomething,
                  msnError: viewModel.viewState.msnForgotPasswordFail,
                  titleBtn: viewModel.viewState.titleRetryButton,
                  onActionPressed: {
            Task {
                await viewModel.action(.retry)
            } 
        })
    }
}

// Para ver unicamente la pantalla
#Preview("Design / Isolated UI") {
    FHKPreview {
        FHKForgotScreen()
        .withPreviewRouter()
    }
}

