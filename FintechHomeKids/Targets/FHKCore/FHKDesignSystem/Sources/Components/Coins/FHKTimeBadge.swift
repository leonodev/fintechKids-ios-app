//
//  FHKTimeBadge.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 31/3/26.
//

import SwiftUI

public struct FHKTimeBadge: View {
    let amount: String
    
    public init(amount: String) {
        self.amount = amount
    }
    
    public var body: some View {
        HStack {
            Image.clock
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: FHKSize.size56, height: FHKSize.size56)
            
            VStack(alignment: .leading) {
                Text("title_time".localized.uppercased())
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
        FHKTimeBadge(amount: "2 Hour")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
