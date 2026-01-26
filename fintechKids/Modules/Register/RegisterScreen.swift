//
//  RegisterScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 23/1/26.
//

import SwiftUI
import FHKDesignSystem

struct RegisterScreen<VM: RegisterScreenVM>: View {
    private let sizeAvatar: CGFloat = FHKSize.size120
    @State var viewModel: VM
    @State private var selectedAvatarName: String? = nil
    
    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading) {
                // field name family
                nameFamilyField
                
                // cardview with credentials
                credentialsField

                // scrollview with avatars list
                avatarsOptions
                
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
                .padding(.top, FHKSize.size20)
            
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
                    .padding(.top, FHKSize.size20)
                
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
    
    var avatarsOptions: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(viewModel.model.avatarIList, id: \.self) { avatar in
                    AvatarView(imageName: avatar.image, size: sizeAvatar)
                        .overlay(
                            RoundedRectangle(cornerRadius: sizeAvatar / 2)
                                .stroke(selectedAvatarName == avatar.name ? Color.yellow : Color.clear, lineWidth: 4)
                        )
                        .onTapGesture {
                            selectedAvatarName = avatar.name
                            print("Seleccionado: \(avatar.name)")
                        }
                        .animation(.easeInOut(duration: 0.2), value: selectedAvatarName)
                }
            }
            .padding()
        }
    }
    
    var registermeButton: some View {
        FHKButtonPrimary(title: viewModel.model.titleRegisterBtn,
                         state: .enabled,
                         mode: .solid,
                         action: {
            Task {
//                        await viewModel.action(.doLogin)
            }
        })
    }
}

#Preview {
    RegisterScreen(viewModel: RegisterScreenVM())
}
