//
//  RegisterScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import FHKDesignSystem
import FHKInjections

struct RegisterScreen<VM: RegisterScreenVM>: View {
    @State var viewModel: VM
    
    @Inject(\.modalManager) var modalManager: FHKModalProtocol
    
    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading) {
                // field name family
                nameFamilyField
                
                // cardview with credentials
                credentialsField
                
                // add new members
                addMembers
                
                // list of members added
                familyMembersList
                
                Spacer()
                // button register
                registermeButton
            }
            .padding()
        }
    }
    
    var nameFamilyField: some View {
        VStack(alignment: .leading) {
            
            Text(viewModel.model.titleFamilyName)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.lunarSand.opacity(0.9))
            
            GradientBorderField(text: $viewModel.model.familyName,
                                placeholder: viewModel.model.familyNamePlaceholder)
            .padding(.top, FHKSize.size04)
        }
    }
    
    var credentialsField: some View {
        BasicCardView(action: {_ in },
                      content: {
            
            VStack(alignment: .leading) {
                Text(viewModel.model.titleEmailFamily)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand.opacity(0.9))
                    .padding(.top, FHKSize.size04)
                
                GradientBorderField(text: $viewModel.model.emailFamily,
                                    placeholder: viewModel.model.emailFamilyPlaceholder)
                .padding(.top, FHKSize.size04)
                
                Text(viewModel.model.titlePassword)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand.opacity(0.9))
                    .padding(.top, FHKSize.size20)
                
                GradientBorderField(text: $viewModel.model.password,
                                    placeholder: viewModel.model.passwordPlaceholder,
                                    isSecure: true)
                
                .padding(.top, FHKSize.size04)
            }
        })
        .padding(.top, FHKSize.size24)
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
            Task { await viewModel.action(.clearInfomember) }

            modalManager.show {
                VStack(alignment: .leading, spacing: FHKSpace.space08) {
                    
                        Text(viewModel.model.titleMemberNewName)
                            .font(.PangramSans.bold(FHKSize.size16))
                            .foregroundColor(FHKColor.lunarSand.opacity(0.9))
                            .padding(.top, FHKSize.size08)
                        
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
                    FHKListItem(name: member.name,
                                avatarName: member.avatarImage,
                                iconName: member.iconName,
                                action: {
                        modalManager.show {
                            VStack(alignment: .leading, spacing: FHKSpace.space08) {
                                FHKConfirmationView(title: viewModel.model.titleRemoveMember,
                                                    message: viewModel.model.msnRemoveMember(name: member.name),
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
        }
    }
    
    var registermeButton: some View {
        FHKButtonPrimary(title: viewModel.model.titleRegisterBtn,
                         state: .enabled,
                         mode: .solid,
                         action: {
            Task {
                await viewModel.action(.registerUser)
            }
        })
    }
}

internal struct NewMemberContentView: View {
    @Inject(\.modalManager) var modalManager: FHKModalProtocol
    @Bindable var viewModel: RegisterScreenVM
    @Binding var selectedAvatarName: String?
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
                             state: viewModel.model.stateButtonCreateMember,
                             action: {
                let name = viewModel.model.memberNewName
                let avatarMember = selectedAvatarName ?? "boy_9"
                let newMember = FamilyMember(name: name, avatarImage: avatarMember)
                
                viewModel.model.familyMembers.append(newMember)
                modalManager.dismiss()
            })
            .padding(.top, FHKSize.size20)
        }
        .padding(.top, FHKSize.size20)
    }
}


#Preview {
    RegisterScreen(viewModel: RegisterScreenVM())
}
