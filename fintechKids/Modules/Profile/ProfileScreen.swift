//
//  ProfileScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 16/2/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKUtils
import FHKDomain

struct ProfileScreen<VM: ProfileScreenVM>: View {
    @State var viewModel: VM
    @State private var selectedLanguageCode: String = ""
    @State private var emailParent: String = ""
    @State private var familyName: String = ""
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.Titles.profile) {
            switch viewModel.viewState.profileState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded, .confirmation:
                ScrollView {
                    VStack {
                        loadedHeaderView
                        
                        closeSessionView
                        
                        loadedFooterView
                    }
                }
            }
        }
        .onAppear {
            Task {
                selectedLanguageCode = await viewModel.getCurrentLanguage()
                emailParent = await viewModel.getEmailParent()
                familyName = await viewModel.getFamilyName()
            }
        }
        .onChange(of: viewModel.viewState.profileState) { _, state in
            switch state {
            case .finish(let result):
                
                switch result {
                case .success:
                    router.popTo(.login)
                    
                case .error:
                    viewModel.fhkModal.show(
                        onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        modalErrorView
                    }
                    )
                }

            case .confirmation:
                viewModel.fhkModal.show(
                    onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        FHKConfirmationView(message: viewModel.viewState.msnCloseSession,
                                            confirmButtonText: viewModel.viewState.btnContinue,
                                            cancelButtonText: viewModel.viewState.btnCancel,
                                            confirmAction: {
                            Task {
                                await viewModel.action(.logout)
                                viewModel.fhkModal.dismiss()
                            }
                        },
                                            cancelAction: {
                            viewModel.viewState.profileState = .loaded
                            viewModel.fhkModal.dismiss()
                        })
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
    
    var loadedHeaderView: some View {
        FHKCardView { _ in } content: {
            VStack {
                HStack {
                    Spacer()
                    
                    VStack {
                        AvatarView(name: emailParent, size: FHKSize.size60)
                        
                        Text(emailParent)
                            .font(.PangramSans.bold(FHKSize.size20))
                            .foregroundColor(FHKColor.lunarSand.opacity(0.6))
                            .padding(.top)
                        
                        Text("\(viewModel.viewState.titleFamily) \(familyName)")
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.basicWhite)
                            .padding(.bottom, FHKSpace.space08)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    var closeSessionView: some View {
        HStack {
            Spacer()
            
            VStack {
                HStack(spacing: FHKSpace.space08) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                    
                    Text(viewModel.viewState.titleCloseSession)
                        .font(.PangramSans.bold(FHKSize.size12))
                        .foregroundColor(FHKColor.basicWhite)
                }
            }
            
            .padding(.horizontal, FHKSpace.space16)
            .padding(.vertical, FHKSpace.space08)
            .background(
                FHKColor.lunarSand.opacity(0.12)
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(FHKColor.basicWhite.opacity(0.2), lineWidth: 1)
            )
            .padding(.trailing)
        }
        .onTapGesture {
            Task {
                await viewModel.action(.openConfirmLogout)
            }
        }
    }
    
    var loadedFooterView: some View {
        FHKCardView { _ in } content: {
            VStack(alignment: .leading, spacing: FHKSpace.space16) {
                
                Text(viewModel.viewState.titleSettingLanguages)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand)
                    .padding(.bottom)
 
                ForEach(viewModel.viewState.languages, id: \.code) { lang in
                    FHKCardView(
                        data: lang.code,
                        isSelected: selectedLanguageCode == lang.code,
                        action: { code in
                            if let newCode = code {
                                selectedLanguageCode = newCode
                                Task {
                                    await viewModel.action(.changeLanguageApp(selectedLanguageCode))
                                }
                            }
                        },
                        content: {
                            HStack {
                                lang.img
                                    .resizable()
                                    .frame(width: FHKSize.size32, height: FHKSize.size32)
                                    .padding(.trailing, FHKSpace.space16)
                                
                                Text(lang.name)
                                    .font(.PangramSans.bold(FHKSize.size16))
                                    .foregroundColor(FHKColor.lunarSand.opacity(0.6))
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
    }
    
    var modalErrorView: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnLogoutResult,
                               type: .error,
                               confirmButtonText: viewModel.viewState.titleBtnModal,
                                confirmAction: {
                viewModel.fhkModal.dismiss()
            })
        }
    }
}

#Preview {
    VStack {
        ProfileScreen(viewModel: ProfileScreenVM())
    }
    .background(FHKColor.indigo)
}
