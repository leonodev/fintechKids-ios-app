//
//  RegisterMembersScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import SwiftUI
import FHKDesignSystem
import FHKDomain
import FHKCore
import FHKUtils

struct RegisterMembersScreen<VM: RegisterMembersScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.members.title) {
            switch viewModel.viewState.registerMembersState {
                
            case .loading:
                loadingView
                
            case .finish, .loaded:
                loadedView
            }
        }
        .onChange(of: viewModel.viewState.registerMembersState) { _, state in
            switch state {
            case .finish(let result):
                
                switch result {
                case .success:
                    viewModel.fhkModal.show(
                        onDismiss: {
                            print("El usuario cerró el modal")
                        }, content: {
                            modalInformativeSuccess
                        }
                    )
                case .error:
                    viewModel.fhkModal.show(
                        onDismiss: {
                            print("El usuario cerró el modal")
                        }, content: {
                            modalInformativeError
                        }
                    )
                }
            default:
                break
            }
        }
    }
    
    var loadingView: some View {
        LoadingView(msn: viewModel.viewState.msnLoading)
    }
    
    var loadedView: some View {
        VStack {
            Spacer()
            
            // informative text
            informativeText
            
            // add new members
            addMembers
            
            // list of members added
            familyMembersList
            
            Spacer()
            registerMembersButton
            Spacer()
        }
        .padding()
    }
    
    var informativeText: some View {
        Text(viewModel.viewState.familyMemberDescription)
            .lineSpacing(4)
            .font(.PangramSans.bold(FHKSize.size16))
            .foregroundColor(FHKColor.lunarSand.opacity(0.5))
            .padding(.vertical)
    }
    
    var addMembers: some View {
        HStack {
            Spacer()
            HStack {
                Text(viewModel.viewState.titleBtnAddMember)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand)
                    .padding(.vertical)
                    .padding(.leading)
                
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: FHKSize.size20, height: FHKSize.size20)
                    .foregroundColor(FHKColor.lunarSand)
                    .padding(.trailing)
            }
            .background(FHKColor.lunarSand.opacity(0.2))
            .cornerRadius(FHKSize.size16)
            .onTapGesture {
                
                viewModel.fhkModal.show(
                    onDismiss: {
                        print("El usuario cerró el modal")
                    }, content: {
                        VStack(alignment: .leading, spacing: FHKSpace.space08) {
                            
                            HStack {
                                Spacer()
                                Text(viewModel.viewState.titleAddNewMember)
                                    .font(.PangramSans.bold(FHKSize.size24))
                                    .foregroundColor(FHKColor.lunarSand.opacity(0.9))
                                    .padding(.top, FHKSize.size08)
                                    .padding(.bottom, FHKSize.size24)
                                Spacer()
                            }
                            
                            FHKTextField(text: $viewModel.viewState.memberNewName,
                                         placeholder: viewModel.viewState.memberNewNamePlaceholder)
                            .padding(.top, FHKSize.size04)
                            
                            NewMemberContentView(viewModel: viewModel,
                                                 selectedAvatarName: $viewModel.viewState.selectedAvatarName)
                        }
                    }
                )
            }
            .padding(.top, FHKSize.size08)
        }
        .frame(maxWidth: .infinity)
    }
    
    var familyMembersList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 10) {
                
                ForEach(viewModel.familyMembers) { member in
                    FHKCreateMemberItem(name: viewModel.getNameMember(member: member),
                                        avatarName: viewModel.getAvatarMember(member: member),
                                        iconName: viewModel.getIconName(member: member),
                                        action: {
                        
                        viewModel.fhkModal.show(
                            onDismiss: {
                                print("El usuario cerró el modal")
                            }, content: {
                                VStack(alignment: .leading, spacing: FHKSpace.space08) {
                                    FHKConfirmationView(message: viewModel.viewState.msnRemoveMember(
                                        name: viewModel.getNameMember(member: member)
                                    ),
                                                        confirmButtonText: viewModel.viewState.titleBtnConfirm,
                                                        cancelButtonText: viewModel.viewState.titleBtnCancel,
                                                        confirmAction: {
                                        Task {
                                            await viewModel.removeMember(member)
                                            viewModel.fhkModal.dismiss()
                                        }
                                    },
                                                        cancelAction: {
                                        viewModel.fhkModal.dismiss()
                                    })
                                }
                            }
                        )
                    })
                }
            }
            .padding(.top)
        }
    }
    
    var registerMembersButton: some View {
        FHKButtonPrimary(title: viewModel.viewState.titleBtnRegisterMember,
                         state: viewModel.viewState.stateBtnRegisterMember(isEnable: viewModel.isEnableBtnRegisterMember),
                         mode: .solid,
                         action: {
            Task {
                await viewModel.action(.registerMembers)
            }
        })
        .padding(.horizontal)
    }
    
    var modalInformativeError: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnUserError,
                               type: .error,
                               confirmButtonText: viewModel.viewState.btnUserError,
                               confirmAction: {
                viewModel.fhkModal.dismiss()
                router.pop()
            })
        }
    }
    
    var modalInformativeSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(message: viewModel.viewState.msnMembersAddedSuccess,
                               type: .success,
                               confirmButtonText: viewModel.viewState.titleModalMembersAddedSuccess,
                               confirmAction: {
                viewModel.fhkModal.dismiss()
                router.pop()
            })
        }
    }
}

internal struct NewMemberContentView: View {
    @Bindable var viewModel: RegisterMembersScreenVM
    @Binding var selectedAvatarName: String
    private let sizeAvatar: CGFloat = FHKSize.size120
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(viewModel.viewState.titleSelectAvatar)
                .foregroundColor(FHKColor.lunarSand)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FHKSpace.space16) {
                    ForEach(viewModel.viewState.avatarIList, id: \.self) { avatar in
                        AvatarView(image: avatar.image, size: sizeAvatar)
                            .overlay(
                                Circle()
                                    .stroke(selectedAvatarName == avatar.name
                                            ? Color.yellow
                                            : Color.clear, lineWidth: FHKSize.size04)
                            )
                            .onTapGesture {
                                selectedAvatarName = avatar.name
                            }
                    }
                }
                .padding()
            }
            
            FHKButtonPrimary(title: viewModel.viewState.titleBtnAddMember,
                             state: viewModel.viewState.stateBtnAddMember,
                             action: {
                Task {
                    await viewModel.action(.newMember)
                    await viewModel.action(.clearInfomember(avatarName: AvatarType.boy_9.name))
                    viewModel.fhkModal.dismiss()
                }
            })
            .padding(.top, FHKSize.size20)
        }
        .padding(.top, FHKSize.size20)
    }
}

#Preview {
    RegisterMembersScreen(viewModel: RegisterMembersScreenVM())
}
