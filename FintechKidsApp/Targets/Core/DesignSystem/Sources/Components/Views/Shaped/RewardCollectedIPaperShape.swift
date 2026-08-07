//
//  RewardCollectedIPaperShape.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 23/4/26.
//

import SwiftUI

struct RewardCollectedIPaperShape: Shape {
    var notchRadius: CGFloat = 3.5
    var largeNotchRadius: CGFloat = 10
    var spacing: CGFloat = 2.5
    var cornerRadius: CGFloat = 12

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerY = height / 2

        let largeNotchTop = centerY - largeNotchRadius
        let largeNotchBottom = centerY + largeNotchRadius
        let notchTotalSize = (notchRadius * 2) + spacing

        path.move(to: CGPoint(x: cornerRadius, y: 0))

        // --- LADO SUPERIOR ---
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        
        // Esquina Superior Derecha
        path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(0),
                    clockwise: false)

        // --- LADO DERECHO ---
        // Troquelado superior derecho
        let numTopNotches = Int((largeNotchTop - cornerRadius) / notchTotalSize)
        for i in 0..<numTopNotches {
            let y = cornerRadius + (CGFloat(i) * notchTotalSize) + notchRadius
            path.addLine(to: CGPoint(x: width, y: y - notchRadius))
            path.addArc(center: CGPoint(x: width, y: y), radius: notchRadius, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        }
        
        // Muesca Grande Derecha
        path.addLine(to: CGPoint(x: width, y: largeNotchTop))
        path.addArc(center: CGPoint(x: width, y: centerY), radius: largeNotchRadius, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        path.addLine(to: CGPoint(x: width, y: largeNotchBottom))

        // Troquelado inferior derecho
        let numBottomNotches = Int(((height - cornerRadius) - largeNotchBottom) / notchTotalSize)
        for i in 0..<numBottomNotches {
            let y = largeNotchBottom + (CGFloat(i) * notchTotalSize) + notchRadius
            path.addLine(to: CGPoint(x: width, y: y - notchRadius))
            path.addArc(center: CGPoint(x: width, y: y), radius: notchRadius, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        }
        
        // Línea hacia esquina inferior derecha
        path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
        path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(0),
                    endAngle: .degrees(90),
                    clockwise: false)

        // --- LADO INFERIOR ---
        path.addLine(to: CGPoint(x: cornerRadius, y: height))
        
        // Esquina Inferior Izquierda
        path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(180),
                    clockwise: false)

        // --- LADO IZQUIERDO ---
        // Troquelado inferior izquierdo (hacia arriba)
        for i in (0..<numBottomNotches).reversed() {
            let y = largeNotchBottom + (CGFloat(i) * notchTotalSize) + notchRadius
            path.addLine(to: CGPoint(x: 0, y: y + notchRadius))
            path.addArc(center: CGPoint(x: 0, y: y), radius: notchRadius, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        }

        // Muesca Grande Izquierda
        path.addLine(to: CGPoint(x: 0, y: largeNotchBottom))
        path.addArc(center: CGPoint(x: 0, y: centerY), radius: largeNotchRadius, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        path.addLine(to: CGPoint(x: 0, y: largeNotchTop))

        // Troquelado superior izquierdo (hacia arriba)
        for i in (0..<numTopNotches).reversed() {
            let y = cornerRadius + (CGFloat(i) * notchTotalSize) + notchRadius
            path.addLine(to: CGPoint(x: 0, y: y + notchRadius))
            path.addArc(center: CGPoint(x: 0, y: y), radius: notchRadius, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        }

        // Línea hacia la esquina superior izquierda
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        
        // Añadimos el arco de la esquina superior izquierda que faltaba
        path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                    radius: cornerRadius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(270),
                    clockwise: false)

        path.closeSubpath()
        return path
    }
}
