//
//  RewardGoldenTicketScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 21/4/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKDomain
import FHKUtils

struct RewardGoldenTicketScreen: View {
    var ticketEntity: GoldenTicketEntity
    
    var body: some View {
        ScreenContainer {
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
