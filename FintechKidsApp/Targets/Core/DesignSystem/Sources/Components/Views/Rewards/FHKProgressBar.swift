//
//  FHKProgressBar.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 3/5/26.
//

import SwiftUI

public struct FHKProgressBarView: View {
    let current: Double
    let total: Double
    let workType: String
    let color: Color
    let isDisabled: Bool
    
    public init(current: Double,
                total: Double,
                workType: String,
                color: Color = FHKColor.basicBlack.opacity(0.7),
                isDisabled: Bool = false
    ) {
        self.current = current
        self.total = total
        self.workType = workType
        self.color = color
        self.isDisabled = isDisabled
    }
    
    public var body: some View {
        // Barra de progreso y Valor faltante
        HStack(spacing: FHKSpace.space12) {
            // Barra de progreso personalizada
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(isDisabled
                              ? FHKColor.gray.opacity(0.2)
                              : FHKColor.purpleBackground.opacity(0.15))
                        .frame(height: FHKSize.size12)

                    Capsule()
                        .fill(isDisabled
                              ? FHKColor.gray.opacity(0.4)
                              : FHKColor.purpleBackground)
                        .frame(width: geo.size.width * CGFloat(min(current / total, 1.0)), height: FHKSize.size12)
                }
            }
            .frame(height: FHKSize.size12)
            
            // Cálculo de lo que falta
            Text("+\(Int(total - current)) \(workType)")
                .font(.PangramSans.bold(FHKSize.size12))
                .foregroundColor(isDisabled
                                 ? FHKColor.gray.opacity(0.4)
                                 : color)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        FHKProgressBarView(current: 20,
                           total: 100,
                           workType: "KidsCoins",
                           color: FHKColor.lunarSand.opacity(0.8))
        
        FHKProgressBarView(current: 20,
                           total: 100,
                           workType: "KidsCoins",
                           color: FHKColor.lunarSand.opacity(0.8),
                           isDisabled: true
        )
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
