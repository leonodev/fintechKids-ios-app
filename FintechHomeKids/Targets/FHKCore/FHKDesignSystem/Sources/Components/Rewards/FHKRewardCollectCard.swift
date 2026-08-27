//
//  RewardCollectCard.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 23/4/26.
//

import SwiftUI

public struct FHKRewardCollectCard: View {
    let state: FHKComponentStateType
    let style: CollectCardStyleType
    let id: Int
    let memberName: String
    let avatarName: String
    let taskName: String
    let rewardName: String
    let titleBtnPay: String
    var action: (Int) -> Void
    
    public init(state: FHKComponentStateType,
                style: CollectCardStyleType,
                id: Int = 0,
                memberName: String = "",
                avatarName: String = "",
                taskName: String = "",
                rewardName: String = "",
                titleBtnPay: String = "",
                action: @escaping (Int) -> Void = { _ in }
    ) {
        self.state = state
        self.style = style
        self.id = id
        self.memberName = memberName
        self.avatarName = avatarName
        self.taskName = taskName
        self.rewardName = rewardName
        self.titleBtnPay = titleBtnPay
        self.action = action
    }
    
    public var body: some View {
        switch state {
        case .skeleton:
            skeletonView
            
        case .error(let error):
            errorView(msnError: error)
            
        case .loaded, .disabled:
            switch style {
            case .glass:
                loadedGlassView
                
            case .punched:
                loadedPunchedView
            }
        }
    }
}

// MARK: View States
private extension FHKRewardCollectCard {
    
    var loadedGlassView: some View {
        HStack(spacing: FHKSpace.space12) {
            AvatarView(image: avatarName.getAvatar, size: FHKSize.size52)
            
            VStack(alignment: .leading, spacing: FHKSpace.space04) {
                Text(memberName)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(state == .disabled
                                     ? FHKColor.silver.opacity(0.5)
                                     : FHKColor.lunarSand)
                
                Group {
                    Text(taskName)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundColor(state == .disabled
                                         ? FHKColor.silver.opacity(0.5)
                                         : FHKColor.lunarSand)
                        .padding(.top, FHKSize.size12)
                    
                    Text("\(rewardName)")
                        .font(.PangramSans.bold(FHKSize.size16))
                        .if(state == .loaded, transform: { view in
                            view.colorDegradeStyle()
                        }, else: { view in
                            view.foregroundStyle(FHKColor.silver.opacity(0.5))
                        })
                       
                }
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.lunarSand.opacity(0.8))
                .lineLimit(1)
            }
            
            Spacer()
            
            VStack {
                // Icono sutil del Golden Ticket
                Image(systemName: "ticket.fill")
                    .font(.PangramSans.bold(FHKSize.size28))
                    .if(state == .loaded, transform: { view in
                        view.colorDegradeStyle()
                    }, else: { view in
                        view.foregroundStyle(FHKColor.silver.opacity(0.5))
                    })
                    .rotationEffect(.degrees(-25))
                    .padding(.bottom, FHKSpace.space08)
                
                Button(action: { action(id) }) {
                    Text(titleBtnPay)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size12))
                        .foregroundColor(state == .disabled
                                         ? FHKColor.silver.opacity(0.5)
                                         : FHKColor.basicWhite)
                        .padding(.horizontal, FHKSpace.space12)
                        .padding(.vertical, FHKSpace.space08)
                        .background(state == .disabled ? FHKColor.gray : FHKColor.wine)
                        .cornerRadius(FHKSize.size08)
                }
                .disabled(state == .disabled)
            }
            
        }
        .padding()
        .frame(height: FHKSize.size112)
        .if(state == .loaded, transform: { view in
            view.cardBackgroundGlassStyle()
        }, else: { view in
            view
                .background(FHKColor.gray.opacity(0.2))
                .clipShape(RewardCollectedIPaperShape())
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        })
    }
    
    var loadedPunchedView: some View {
        HStack(spacing: 0) {
            AvatarView(name: avatarName, size: FHKSize.size52)
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: FHKSpace.space04) {
                Text(memberName)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(state == .disabled
                                     ? FHKColor.silver.opacity(0.5)
                                     : FHKColor.purpleCheckedBackground)
                
                Text(taskName)
                    .font(.PangramSans.medium(FHKSize.size12))
                    .foregroundColor(state == .disabled
                                     ? FHKColor.silver.opacity(0.5)
                                     : FHKColor.purpleCheckedBackground.opacity(0.8))
                
                Text(rewardName)
                    .font(.PangramSans.medium(FHKSize.size16))
                    .foregroundColor(state == .disabled
                                     ? FHKColor.silver.opacity(0.5)
                                     : FHKColor.purpleCheckedBackground.opacity(0.6))
            }
            .padding(.leading, FHKSpace.space08)
            
            // Divisor Vertical
            Rectangle()
                .fill(state == .disabled
                      ? FHKColor.silver.opacity(0.5)
                      : FHKColor.shadowColor)
                .frame(width: 1, height: FHKSize.size60)
                .padding(.horizontal, FHKSpace.space12)
            
            // Sección Acción
            VStack(spacing: FHKSpace.space08) {
    
                Button(action: { action(id) }) {
                    Text(titleBtnPay)
                        .multilineTextAlignment(.center)
                        .font(.PangramSans.bold(FHKSize.size12))
                        .foregroundColor(state == .disabled
                                         ? FHKColor.silver.opacity(0.8)
                                         : FHKColor.basicWhite)
                        .padding(.horizontal, FHKSpace.space12)
                        .padding(.vertical, FHKSpace.space12)
                        .background(state == .disabled ? FHKColor.gray : FHKColor.wine)
                        .cornerRadius(FHKSize.size08)
                }
                .disabled(state == .disabled)
            }
            .padding(.trailing, FHKSpace.space24)
        }
        .frame(height: FHKSize.size120)
        .if(state == .loaded, transform: { view in
            view.background(
                RewardCollectedIPaperShape()
                    .colorDegradeStyle()
            )
            
            .overlay(
                RewardCollectedIPaperShape()
                    .stroke(FHKColor.shadowColor.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 2]))
            )
            
            .clipShape(RewardCollectedIPaperShape())
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        }, else: { view in
            view
                .background(FHKColor.gray.opacity(0.2))
                .clipShape(RewardCollectedIPaperShape())
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
        })
    }
    
    @ViewBuilder
    func errorView(msnError: String) -> some View {
        VStack(spacing: FHKSpace.space12) {
            Image(systemName: "xmark.icloud.fill")
                .font(.system(size: FHKSize.size48))
                .foregroundColor(.gray.opacity(0.6))

            Text(msnError)
                .font(.PangramSans.medium(FHKSize.size16))
                .foregroundColor(.white.opacity(0.4))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: FHKSize.size20)
                .fill(.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: FHKSize.size20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: FHKSize.size20))
    }
    
    var skeletonView: some View {
        HStack(spacing: FHKSpace.space12) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size52, height: FHKSize.size52)
                .blinkCircleSkeleton()
            
            VStack(alignment: .leading, spacing: FHKSpace.space12) {
                // Representación del Texto
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size52, height: FHKSize.size16)
                
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size160, height: FHKSize.size16)
                
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size96, height: FHKSize.size16)
            }
            .blinkTextSkeleton()
            
            Spacer()
            
            // Icono sutil del Golden Ticket
            Image(systemName: "ticket.fill")
                .foregroundStyle(.gray.opacity(0.4))
                .font(.PangramSans.bold(FHKSize.size32))
                .rotationEffect(.degrees(-25))
                .blinkTextSkeleton()
        }
        .padding()
        .cardBackgroundGlassStyle()
    }
}

public extension FHKRewardCollectCard {
    @ViewBuilder
    public static func skeletons(count: Int, style: CollectCardStyleType) -> some View {
        ForEach(0..<count, id: \.self) { _ in
            FHKRewardCollectCard(state: .skeleton, style: style)
        }
    }
}

#Preview {
    var rewardsState: FHKComponentStateType = .disabled
    let rewardsCollected: [DummyCollectedEntity] = [
        DummyCollectedEntity(id: 0,
                              createdDate: "createdDate",
                              member: DummyMemberEntity(
                                id: UUID(),
                                emailParent: "emailParent",
                                memberName: "memberName",
                                familyName: "familyName",
                                avatarName: "boy_9"),
                              parentEmail: "parentEmail",
                              nameReward: "nameReward",
                              claimedValue: "claimedValue",
                              state: "state",
                              nameTask: "nameTask"),
        DummyCollectedEntity(id: 1,
                              createdDate: "createdDate",
                              member: DummyMemberEntity(
                                id: UUID(),
                                emailParent: "emailParent",
                                memberName: "memberName",
                                familyName: "familyName",
                                avatarName: "boy_3"),
                              parentEmail: "parentEmail",
                              nameReward: "nameReward",
                              claimedValue: "claimedValue",
                              state: "state",
                              nameTask: "nameTask")
    ]
    
    VStack {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: FHKSpace.space16) {
                
                switch rewardsState {
                    
                case .skeleton:
                    FHKRewardCollectCard.skeletons(count: 3, style: .glass)
                    
                case .loaded, .disabled:
                    ForEach(rewardsCollected) { ticket in
                        FHKRewardCollectCard(state: rewardsState,
                                          style: .punched,
                                          id: 1,
                                          memberName: ticket.member.memberName,
                                          avatarName: ticket.member.avatarName,
                                          taskName: ticket.nameTask,
                                          rewardName: ticket.nameReward,
                                          titleBtnPay: "PAGAR")
                    }
                    
                case .error(let msn):
                    FHKRewardCollectCard(state: .error(msn), style: .glass)
                }
            }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}

internal struct DummyCollectedEntity: Identifiable, Equatable {
    public let id: Int
    public let createdDate: String
    public let member: DummyMemberEntity
    public let parentEmail: String
    public let nameReward: String
    public let claimedValue: String
    public let state: String
    public let nameTask: String
   
    
    public init(id: Int,
                createdDate: String,
                member: DummyMemberEntity,
                parentEmail: String,
                nameReward: String,
                claimedValue: String,
                state: String,
                nameTask: String
    ) {
        self.id = id
        self.createdDate = createdDate
        self.member = member
        self.parentEmail = parentEmail
        self.nameReward = nameReward
        self.claimedValue = claimedValue
        self.state = state
        self.nameTask = nameTask
    }
}

internal struct DummyMemberEntity: Identifiable, Equatable {
    public let id: UUID
    public let emailParent: String
    public let memberName: String
    public let familyName: String
    public let avatarName: String
    public var iconName: String = "trash"
    
    
    public init(id: UUID = UUID(),
                emailParent: String,
                memberName: String,
                familyName: String,
                avatarName: String = "boy_9",
                
    ) {
        self.id = id
        self.emailParent = emailParent
        self.memberName = memberName
        self.familyName = familyName
        self.avatarName = avatarName
    }
}
