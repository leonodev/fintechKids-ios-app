//
//  RegisterScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import FHKDesignSystem
import FHKCore
import FHKDomain
import FHKUtils

struct RegisterScreen<VM: RegisterScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.register) {
            switch viewModel.viewState.registerState {
                
            case .loading:
                loadingView
                
            case .loaded, .finish:
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.registerState) { _, state in
            switch state {
            case .finish(.success):
                viewModel.fhkModal.show(
                    onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        resultModalSuccess
                    }
                )
            case .finish(result: .error):
                viewModel.fhkModal.show(
                    onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        resultModalError
                    }
                )
            default:
                break
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer()
                
                LottieView(animationName: Lotties.register,
                           loopMode: .loop,
                           contentMode: .scaleAspectFit)
                .frame(height: 200)
                
                // field name family
                nameFamilyField
                
                // text informative
                informativeText

                // cardview with credentials
                credentialsField
                
                Spacer()
                // button register
                registermeButton
                
                Spacer()
            }
            .padding()
        }
    }
    
    var nameFamilyField: some View {
        VStack(alignment: .leading) {
            
            FHKTextField(text: $viewModel.viewState.familyName,
                         placeholder: viewModel.viewState.familyNamePlaceholder)
            .padding(.top, FHKSize.size04)
        }
    }
    
    var informativeText: some View {
        Text(viewModel.viewState.registerEmailInstruction)
            .lineSpacing(4)
            .multilineTextAlignment(.leading)
            .font(.PangramSans.bold(FHKSize.size16))
            .foregroundColor(FHKColor.lunarSand.opacity(0.5))
            .padding()
    }
    
    var credentialsField: some View {
        FHKCardView(action: {_ in },
                      content: {
            
            VStack(alignment: .leading) {
                FHKTextField(text: $viewModel.viewState.emailFamily,
                             placeholder: viewModel.viewState.emailFamilyPlaceholder)
                .padding(.top, FHKSize.size04)
                
                FHKTextField(text: $viewModel.viewState.password,
                             placeholder: viewModel.viewState.passwordPlaceholder,
                             isSecure: true)
                .padding(.top, FHKSize.size12)
                
                FHKTextField(text: $viewModel.viewState.confirmPassword,
                             placeholder: viewModel.viewState.confirmPasswordPlaceholder,
                             isSecure: true)
                .padding(.top, FHKSize.size12)
                
                FHKTextField(text: $viewModel.viewState.pinApproveTask,
                             placeholder: viewModel.viewState.pinApproveTaskPlaceholder,
                             isSecure: true)
                .padding(.top, FHKSize.size12)
            }
        })
        .padding(.top, FHKSize.size24)
    }
    
    var registermeButton: some View {
        FHKButtonPrimary(title: viewModel.viewState.titleRegisterBtn,
                         state: viewModel.viewState.isBtnContinueEnable,
                         mode: .solid,
                         action: {
            Task {
                await viewModel.action(.registerUser)
            }
        })
    }
    
    var resultModalSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnRegisterSuccess,
                               type: .success,
                               confirmButtonText: viewModel.viewState.titleButtonContinue,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
                router.pop()
            })
        }
    }
    
    var resultModalError: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnRegisterFail.capitalizingFirstLetter(),
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleBtnOperationError,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
            })
        }
    }
}

#Preview {
    RegisterScreen(viewModel: RegisterScreenVM())
}
