//
//  SimulatedBarcode.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 28/3/26.
//

import SwiftUI

public struct SimulatedBarcode: View {
    private let bars: [CGFloat] = [
        2,1,3,1,2,2,1,3,1,1,2,1,3,2,1,1,2,3,1,2,
        1,2,1,1,3,1,2,2,1,3,1,1,2,2,1,2,1,3,2,1,
        1,2,3,1,2,1,1,3,2,1,2,1,3,1,2,2,1,1,3,2
    ]
    private var totalUnits: CGFloat {
        bars.reduce(0, +)
    }

    public var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(Array(bars.enumerated()), id: \.offset) { idx, w in
                    Rectangle()
                        .fill(idx % 2 == 0 ? Color.black : Color.white)
                        .frame(width: w * geo.size.width / totalUnits)
                }
            }
        }
    }
}
