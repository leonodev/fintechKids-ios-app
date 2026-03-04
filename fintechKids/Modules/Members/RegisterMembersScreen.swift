//
//  RegisterMembersScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import SwiftUI
import FHKDesignSystem
import FHKCore
import FHKUtils

struct RegisterMembersScreen<VM: RegisterMembersScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    
    var body: some View {
        ScreenContainer(title: Routes.members.title) {
            switch viewModel.viewState.addMemberState {
    
            default:
                contentView
            }
        }
        .onChange(of: viewModel.viewState.addMemberState) { _, state in
            switch state {
            case .error:
                viewModel.modalManager.show {
                    modalInformativeError
                }
            case .finish:
                viewModel.modalManager.show {
                    modalInformativeSuccess
                }
                
            default:
                break
            }
        }
    }
    
    var contentView: some View {
        VStack {
            Spacer()
            
            // informative text
            informativeText
            
            // field name family
            nameFamilyField
            
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
    
    var nameFamilyField: some View {
        VStack(alignment: .leading) {
    
            GradientBorderField(text: $viewModel.viewState.familyName,
                                placeholder: viewModel.viewState.familyNamePlaceholder)
            .padding(.top, FHKSize.size04)
        }
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

            viewModel.modalManager.show {
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
                        
                    GradientBorderField(text: $viewModel.viewState.memberNewName,
                                        placeholder: viewModel.viewState.memberNewNamePlaceholder)
                    .padding(.top, FHKSize.size04)
                        
                    NewMemberContentView(viewModel: viewModel,
                                        selectedAvatarName: $viewModel.viewState.selectedAvatarName)
                    }
                }
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
                        viewModel.modalManager.show {
                            VStack(alignment: .leading, spacing: FHKSpace.space08) {
                                FHKConfirmationView(title: viewModel.viewState.titleRemoveMember,
                                                    message: viewModel.viewState.msnRemoveMember(
                                                        name: viewModel.getNameMember(member: member)
                                                    ),
                                                    confirmButtonText: viewModel.viewState.titleBtnConfirm,
                                                    cancelButtonText: viewModel.viewState.titleBtnCancel,
                                                    confirmAction: {
                                    Task {
                                        await viewModel.removeMember(member)
                                        viewModel.modalManager.dismiss()
                                    }
                                },
                                                    cancelAction: {
                                    viewModel.modalManager.dismiss()
                                })
                            }
                        }
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
            FHKInformationView(title: viewModel.viewState.titleUserError,
                               message: viewModel.viewState.msnUserError,
                               type: .error,
                               confirmButtonText: viewModel.viewState.btnUserError,
                                confirmAction: {
                viewModel.modalManager.dismiss()
                router.pop()
            })
        }
    }
    
    var modalInformativeSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(title: viewModel.viewState.titleMembersAddedSuccess,
                               message: viewModel.viewState.msnMembersAddedSuccess,
                               type: .success,
                               confirmButtonText: viewModel.viewState.titleModalMembersAddedSuccess,
                                confirmAction: {
                viewModel.modalManager.dismiss()
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
                        AvatarView(imageName: avatar.image, size: sizeAvatar)
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
                    viewModel.modalManager.dismiss()
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
