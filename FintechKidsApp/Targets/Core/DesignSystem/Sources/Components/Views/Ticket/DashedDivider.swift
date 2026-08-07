//
//  DashedDivider.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 28/3/26.
//

import SwiftUI

public struct DashedDivider: View {
    private var color: Color = Color(hex: "7A5C00").opacity(0.4)
    
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: 1)
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 4]))
                    .foregroundColor(color)
            )
            .padding(.horizontal, FHKSpace.space04)
    }
}
