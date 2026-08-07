//
//  RewardCollectPunchedItem.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 23/4/26.
//

import SwiftUI

public struct FHKRewardCollectPunchedItem: View {
    let id: Int
    let memberName: String
    let avatarName: String
    let nameTask: String
    let nameReward: String
    let titleBtnPay: String
    var action: (Int) -> Void
    
    public init(id: Int,
                memberName: String,
                avatarName: String,
                nameTask: String,
                nameReward: String,
                titleBtnPay: String,
                action: @escaping (Int) -> Void
    ) {
        self.id = id
        self.memberName = memberName
        self.avatarName = avatarName
        self.nameTask = nameTask
        self.nameReward = nameReward
        self.titleBtnPay = titleBtnPay
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            
            AvatarView(name: avatarName, size: FHKSize.size52)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: FHKSpace.space04) {
                Text(memberName)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.purpleCheckedBackground)
                
                Text(nameTask)
                    .font(.PangramSans.medium(FHKSize.size12))
                    .foregroundColor(FHKColor.purpleCheckedBackground.opacity(0.8))
                
                Text(nameReward)
                    .font(.PangramSans.medium(FHKSize.size16))
                    .foregroundColor(FHKColor.purpleCheckedBackground.opacity(0.6))
            }
            .padding(.leading, FHKSpace.space08)
            
            // Divisor Vertical
            Rectangle()
                .fill(FHKColor.shadowColor)
                .frame(width: 1, height: FHKSize.size60)
                .padding(.horizontal, FHKSpace.space12)
            
            // Sección Acción
            VStack(spacing: FHKSpace.space08) {
    
                Button(action: { action(id) }) {
                    Text(titleBtnPay)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size12))
                        .foregroundColor(.white)
                        .padding(.horizontal, FHKSpace.space12)
                        .padding(.vertical, FHKSpace.space12)
                        .background(FHKColor.wine)
                        .cornerRadius(FHKSize.size08)
                }
            }
            .padding(.trailing, FHKSpace.space24)
        }
        .frame(width: 270, height: FHKSize.size120)
        .background(
            RewardCollectedIPaperShape()
                .colorDegradeStyle()
        )
        .overlay(
            RewardCollectedIPaperShape()
                .stroke(FHKColor.shadowColor.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 2]))
        )
        .clipShape(RewardCollectedIPaperShape())
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    VStack {
        FHKRewardCollectPunchedItem(id: 1,
                                 memberName: "memberName",
                                 avatarName: "avatarName",
                                 nameTask: "nameTask",
                                 nameReward: "nameReward",
                                 titleBtnPay: "PAY NOW",
                                 action: { id in
            print("pay tkt with id: \(id)")
        })
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
