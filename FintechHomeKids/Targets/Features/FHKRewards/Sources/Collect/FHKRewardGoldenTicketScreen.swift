//
//  FHKRewardGoldenTicketScreen.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain
import FLibUtils

public struct FHKRewardGoldenTicketScreen: View {
    // @Comentado, pasar de alguna manera la info
    var ticketEntity: FHKGoldenTicketEntity = FHKGoldenTicketEntity(
        recipientName: "recipientName",
        taskDescription: "taskDescription",
        reward: "reward",
        ticketCode: "ticketCode")
    
    public init() {}
    
    public var body: some View {
        FHKScreenContainer {
            VStack {
                Text("msn_congratulations_reward_golden_ticket".localized().capitalizingFirstLetter())
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand)
                    .padding()
                
                GoldenTicketView(recipientName: ticketEntity.recipientName,
                                 taskDescription: ticketEntity.taskDescription,
                                 reward: ticketEntity.reward,
                                 ticketCode: "\(ticketEntity.ticketCode)")
            }
        }
    }
}
