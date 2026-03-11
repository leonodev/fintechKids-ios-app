//
//  MemberDetailScreen.swift
//  fintechKids
//
//  Created by Fredy Leon on 9/3/26.
//

import SwiftUI
import FHKCore
import FHKDesignSystem
import FHKUtils
import FHKDomain

struct MemberDetailScreen<VM: MemberDetailScreenVM>: View {
    @State var viewModel: VM
    let member: MemberEntity
    
    var body: some View {
        ScreenContainer(title: member.memberName.uppercased()) {
            VStack {
                StarCoinView(text: "StarCoins", textError: "Error", balance: "1,250")
                
                Spacer()
            }    
        }
    }
}
