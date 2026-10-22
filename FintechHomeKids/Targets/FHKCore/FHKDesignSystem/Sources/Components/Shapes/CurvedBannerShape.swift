//
//  CurvedBannerShape.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 8/10/26.
//

import SwiftUI

public struct CurvedBannerShape: Shape {
    public var curveHeight: CGFloat
    
    public init(curveHeight: CGFloat = FHKSize.size32) {
        self.curveHeight = curveHeight
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - curveHeight))
        
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - curveHeight),
            control: CGPoint(x: rect.width / 2, y: rect.height + curveHeight)
        )
        
        path.closeSubpath()
        return path
    }
}
