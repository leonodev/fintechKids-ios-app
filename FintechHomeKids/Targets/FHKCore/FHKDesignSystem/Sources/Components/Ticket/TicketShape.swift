//
//  TicketShape.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 28/3/26.
//

import SwiftUI

public struct TicketShape: Shape {
    private var notchRadius: CGFloat = 18
    private var cornerRadius: CGFloat = 18
    /// Posición vertical de las muescas (0 = arriba, 1 = abajo)
    private var notchRatio: CGFloat = 0.76

    public func path(in rect: CGRect) -> Path {
        let nr = notchRadius
        let cr = cornerRadius
        let notchY = rect.minY + rect.height * notchRatio
        var p = Path()

        // Esquina superior izquierda
        p.move(to: CGPoint(x: rect.minX + cr, y: rect.minY))
        // Borde superior
        p.addLine(to: CGPoint(x: rect.maxX - cr, y: rect.minY))
        p.addArc(center: CGPoint(x: rect.maxX - cr, y: rect.minY + cr),
                 radius: cr, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        // Borde derecho — parte superior
        p.addLine(to: CGPoint(x: rect.maxX, y: notchY - nr))
        // Muesca derecha (semicírculo hacia adentro)
        p.addArc(center: CGPoint(x: rect.maxX, y: notchY),
                 radius: nr, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        // Borde derecho — parte inferior
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cr))
        p.addArc(center: CGPoint(x: rect.maxX - cr, y: rect.maxY - cr),
                 radius: cr, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        // Borde inferior
        p.addLine(to: CGPoint(x: rect.minX + cr, y: rect.maxY))
        p.addArc(center: CGPoint(x: rect.minX + cr, y: rect.maxY - cr),
                 radius: cr, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        // Borde izquierdo — parte inferior
        p.addLine(to: CGPoint(x: rect.minX, y: notchY + nr))
        // Muesca izquierda (semicírculo hacia adentro)
        p.addArc(center: CGPoint(x: rect.minX, y: notchY),
                 radius: nr, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        // Borde izquierdo — parte superior
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cr))
        p.addArc(center: CGPoint(x: rect.minX + cr, y: rect.minY + cr),
                 radius: cr, startAngle: .degrees(180), endAngle: .degrees(-90), clockwise: false)
        p.closeSubpath()
        return p
    }
}
