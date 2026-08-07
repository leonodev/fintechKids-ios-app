//
//  FHKTimeBadge.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 31/3/26.
//

import SwiftUI

public struct FHKTimeBadge: View {
    let amount: String
    let size: CGFloat
    
    public init(amount: String,
                size: CGFloat = FHKSize.size12
    ) {
        self.amount = amount
        self.size = size
    }
    
    public var body: some View {
        HStack(spacing: FHKSpace.space16) {
            Image(systemName: "watch.analog")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
            
            VStack(alignment: .leading) {
                Text("\(amount)")
                    .font(.PangramSans.bold(size))
                
                Text("Tu tiempo actual")
                    .font(.PangramSans.bold(size / 2))
                    .foregroundStyle(FHKColor.stone)
            }
        }
        .padding(.vertical, size / 2)
        .padding(.horizontal, size)
        .foregroundColor(FHKColor.yellow)
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

#Preview {
    VStack {
        FHKTimeBadge(amount: "2 hours",
                     size: 40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
