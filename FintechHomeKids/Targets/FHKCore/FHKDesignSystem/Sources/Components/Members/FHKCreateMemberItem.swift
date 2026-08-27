//
//  FHKCreateMemberItem.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 29/1/26.
//

import SwiftUI

public struct FHKCreateMemberItem: View {
    let name: String
    let amount: String
    let avatarName: String
    let iconName: String
    let identifier: String
    var action: () -> Void
    
    public init(name: String,
                amount: String = "0,00",
                avatarName: String,
                iconName: String,
                identifier: String = "",
                action: @escaping () -> Void) {
        self.name = name
        self.amount = amount
        self.avatarName = avatarName
        self.iconName = iconName
        self.identifier = identifier
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading) {
                
                Text(name)
                    .font(.PangramSans.medium(16))
                    .foregroundColor(.white)
                    .padding(.leading, 04)
                
                FHKCoinBadge(amount: amount)
            }
 
            Spacer()
            
            AvatarView(image: avatarName.getAvatar, size: FHKSize.size44)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
            
            Button(action: action) {
                Image(systemName: iconName)
                    .resizable()
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(FHKColor.yellow)
                    .frame(width: FHKSize.size24, height: FHKSize.size24)
            }
        }
        .accessibilityIdentifier(identifier)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

#Preview {
    VStack {
        
        Group {
            FHKCreateMemberItem(name: "Pepito Perez",
                        avatarName: AvatarType.boy_3.name,
                        iconName: ImageSystem.trash.name,
                        action: {
                
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(FHKColor.indigo)
        }
        
    }
}
