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
    var ticketEntity: FHKGoldenTicketEntity
    
    public init(ticketEntity: FHKGoldenTicketEntity) {
        self.ticketEntity = ticketEntity
    }
    
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
