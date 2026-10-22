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
    
    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(current / total, 1.0)
    }
    
    private var percentageText: String {
        "\(Int(progress * 100))%"
    }
    
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
            
            VStack {
                
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
                
                HStack {
                    Text(percentageText)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundColor(FHKColor.purpleBackground)
                    
                    Spacer()
                    Text("\(Int(current))/\(Int(total)) Coins")
                        .font(.PangramSans.bold(FHKSize.size12))
                        .foregroundColor(FHKColor.purpleBackground)
                }   
            }
            
//            // Cálculo de lo que falta
//            Text("+\(Int(total - current)) \(workType)")
//                .font(.PangramSans.bold(FHKSize.size12))
//                .foregroundColor(isDisabled
//                                 ? FHKColor.gray.opacity(0.4)
//                                 : color)
//                .fixedSize(horizontal: true, vertical: false)
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
