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

struct AddMemberScreen<VM: AddMemberScreenVM>: View {
    @State var viewModel: VM
    @NavigationRouterWrapper<Routes> private var router
    @Inject(\.modalManager) var modalManager: FHKModalProtocol
    
    var body: some View {
        ScreenContainer {
            switch viewModel.model.addMemberState {
    
            default:
                contentView
            }
        }
        .onChange(of: viewModel.model.addMemberState) { _, state in
            
        }
    }
    
    var contentView: some View {
        VStack {
            // field name family
            nameFamilyField
            
            // add new members
            addMembers
            
            // list of members added
            familyMembersList
        }
        .padding()
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
}

internal struct NewMemberContentView: View {
    @Inject(\.modalManager) var modalManager: FHKModalProtocol
    @Bindable var viewModel: AddMemberScreenVM
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
    AddMemberScreen(viewModel: AddMemberScreenVM())
}
