//
//  FHKCoinBadge.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 20/2/26.
//

import SwiftUI

public struct FHKCoinBadge: View {
    let amount: String
    let size: CGFloat
    
    public init(amount: String, size: CGFloat = FHKSize.size12) {
        self.amount = amount
        self.size = size
    }
    
    public var body: some View {
        HStack(spacing: FHKSpace.space16) {
            Image(systemName: ImageSystem.star_fill.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
            
            VStack(alignment: .leading) {
                Text("KidsCoins: \(amount)")
                    .font(.PangramSans.bold(size))
                
                Text("Tu saldo actual")
                    .font(.PangramSans.bold(size / 2))
                    .foregroundStyle(FHKColor.stone)
            }
        }
        .padding(.vertical, size / 2)
        .padding(.horizontal, size)
        .foregroundColor(FHKColor.yellow)
        .background(Color.indigo)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack {
        FHKCoinBadge(amount: "200", size: 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
