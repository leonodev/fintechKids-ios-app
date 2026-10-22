//
//  FHKCoinBadge.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 20/2/26.
//

import SwiftUI

public struct FHKCoinBadge: View {
    let amount: String
    
    public init(amount: String) {
        self.amount = amount
    }
    
    public var body: some View {
        HStack {
            Image.coinSingle
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FHKSize.size52, height: FHKSize.size52)
            
            VStack(alignment: .leading) {
                Text("KidsCoins".uppercased())
                    .font(.PangramSans.light(FHKSize.size12))
                    .foregroundStyle(FHKColor.basicBlack)
                
                Text("\(amount)")
                    .font(.PangramSans.bold(FHKSize.size20))
                    .foregroundStyle(FHKColor.basicBlack)
            }
        }
        .padding(.vertical, FHKSpace.space16)
        .padding(.horizontal, FHKSpace.space16)
        .foregroundColor(FHKColor.yellow)
        .background(FHKColor.lunarSand)
        .cornerRadius(FHKSize.size16)
    }
}

#Preview {
    VStack {
        FHKCoinBadge(amount: "1,250")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
