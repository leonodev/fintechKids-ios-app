//
//  AddMemberScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 1/2/26.
//

import SwiftUI
import FHKDesignSystem
import FHKInjections
import FHKCore
import FHKUtils
import FHKStorage
import FHKDomain

struct AddMemberScreen<VM: AddMemberScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    @Inject(\.modalManager) var modalManager: FHKModalProtocol
    
    var body: some View {
        ScreenContainer(title: Routes.members.title) {
            switch viewModel.model.addMemberState {
    
            default:
                contentView
            }
        }
        .onChange(of: viewModel.model.addMemberState) { _, state in
            switch state {
            case .error:
                modalManager.show {
                    modalInformativeError
                }
            case .finish:
                modalManager.show {
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
        Text(viewModel.model.familyMemberDescription)
            .lineSpacing(4)
            .font(.PangramSans.bold(FHKSize.size16))
            .foregroundColor(FHKColor.lunarSand.opacity(0.5))
            .padding(.vertical)
    }
    
    var nameFamilyField: some View {
        VStack(alignment: .leading) {
    
            GradientBorderField(text: $viewModel.model.familyName,
                                placeholder: viewModel.model.familyNamePlaceholder)
            .padding(.top, FHKSize.size04)
        }
    }
    
    var addMembers: some View {
        HStack {
            Spacer()
        HStack {
            Text(viewModel.model.titleBtnAddMember)
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

            modalManager.show {
                VStack(alignment: .leading, spacing: FHKSpace.space08) {
                    
                    HStack {
                        Spacer()
                        Text(viewModel.model.titleAddNewMember)
                            .font(.PangramSans.bold(FHKSize.size24))
                            .foregroundColor(FHKColor.lunarSand.opacity(0.9))
                            .padding(.top, FHKSize.size08)
                            .padding(.bottom, FHKSize.size24)
                        Spacer()
                    }
                        
                    GradientBorderField(text: $viewModel.model.memberNewName,
                                        placeholder: viewModel.model.memberNewNamePlaceholder)
                    .padding(.top, FHKSize.size04)
                        
                    NewMemberContentView(viewModel: viewModel,
                                        selectedAvatarName: $viewModel.model.selectedAvatarName)
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
                
                ForEach(viewModel.model.familyMembers) { member in
                    FHKCreateMemberItem(name: member.member_name,
                                        avatarName: member.avatar_name,
                                        iconName: member.iconName,
                                        action: {
                        modalManager.show {
                            VStack(alignment: .leading, spacing: FHKSpace.space08) {
                                FHKConfirmationView(title: viewModel.model.titleRemoveMember,
                                                    message: viewModel.model.msnRemoveMember(name: member.member_name),
                                                    confirmButtonText: viewModel.model.titleBtnConfirm,
                                                    cancelButtonText: viewModel.model.titleBtnCancel,
                                                    confirmAction: {
                                    Task {
                                        await viewModel.removeMember(member)
                                        modalManager.dismiss()
                                    }
                                },
                                                    cancelAction: {
                                    modalManager.dismiss()
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
        FHKButtonPrimary(title: viewModel.model.titleBtnRegisterMember,
                         state: viewModel.model.stateBtnRegisterMember,
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
            FHKInformationView(title: viewModel.model.titleUserError,
                               message: viewModel.model.msnUserError,
                               type: .error,
                               confirmButtonText: viewModel.model.btnUserError,
                                confirmAction: {
                modalManager.dismiss()
                router.pop()
            })
        }
    }
    
    var modalInformativeSuccess: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            FHKInformationView(title: viewModel.model.titleMembersAddedSuccess,
                               message: viewModel.model.msnMembersAddedSuccess,
                               type: .success,
                               confirmButtonText: viewModel.model.titleModalMembersAddedSuccess,
                                confirmAction: {
                modalManager.dismiss()
                router.pop()
            })
        }
    }
}

internal struct NewMemberContentView: View {
    // Properties Injected
    var modalManager: any FHKModalProtocol {
        inject.modalManager
    }
   
    @Bindable var viewModel: AddMemberScreenVM
    @Binding var selectedAvatarName: String
    private let sizeAvatar: CGFloat = FHKSize.size120

    var body: some View {
        VStack(alignment: .leading) {
            
            Text(viewModel.model.titleSelectAvatar)
                .foregroundColor(FHKColor.lunarSand)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FHKSpace.space16) {
                    ForEach(viewModel.model.avatarIList, id: \.self) { avatar in
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
            
            FHKButtonPrimary(title: viewModel.model.titleBtnAddMember,
                             state: viewModel.model.stateBtnAddMember,
                             action: {
                Task {
                    await viewModel.action(.newMember)
                    await viewModel.action(.clearInfomember)
                    modalManager.dismiss()
                }  
            })
            .padding(.top, FHKSize.size20)
        }
        .padding(.top, FHKSize.size20)
    }
}

#Preview {
    AddMemberScreen(viewModel: AddMemberScreenVM())
}
