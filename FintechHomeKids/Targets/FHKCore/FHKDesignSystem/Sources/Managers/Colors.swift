//
//  Colors.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/11/25.
//

import SwiftUI

public extension Bundle {
    static var designSystem: Bundle {
        return .module
    }
}

// MARK: - Design System Color Extension
public struct FHKColor {

    /// FuchsiaPink color from the asset catalog
    public static var fuchsiaPink: Color {
        Color("fuchsiaPink", bundle: .designSystem)
    }
    
    /// Gray color from the asset catalog
    public static var gray: Color {
        Color("gray", bundle: .designSystem)
    }
    
    /// Lunar Sand color from the asset catalog
    public static var lunarSand: Color {
        Color("lunarSand", bundle: .designSystem)
    }
    
    /// Pastel Pink color from the asset catalog
    public static var pastelPink: Color {
        Color("pastelPink", bundle: .designSystem)
    }
    
    /// Silver color from the asset catalog
    public static var silver: Color {
        Color("silver", bundle: .designSystem)
    }
    
    /// Stone color from the asset catalog
    public static var stone: Color {
        Color("stone", bundle: .designSystem)
    }
    
    /// Ultra Purple color from the asset catalog
    public static var ultraPurple: Color {
        Color("ultraPurple", bundle: .designSystem)
    }
    
    /// Wine color from the asset catalog
    public static var wine: Color {
        Color("wine", bundle: .designSystem)
    }
    
    /// Basic White color from the asset catalog
    public static var basicWhite: Color {
        Color("basicWhite", bundle: .designSystem)
    }
    
    /// Basic Black color from the asset catalog
    public static var basicBlack: Color {
        Color("basicBlack", bundle: .designSystem)
    }
    
    /// Shadow color from the asset catalog
    public static var shadowColor: Color {
        Color("shadow", bundle: .designSystem)
    }
    
    /// Text color for enabled state from the asset catalog
    public static var textColorEnabled: Color {
        Color("textColorEnabled", bundle: .designSystem)
    }
    
    /// Primary background color from the asset catalog
    public static var backgroundPrimary: Color {
        Color("backgroundPrimary", bundle: .designSystem)
    }
    
    /// Primary background color from the asset catalog
    public static var success: Color {
        Color("success", bundle: .designSystem)
    }
    
    /// Primary background color from the asset catalog
    public static var warning: Color {
        Color("warning", bundle: .designSystem)
    }
    
    /// Primary background color from the asset catalog
    public static var error: Color {
        Color("error", bundle: .designSystem)
    }
    
    public static var indigo: Color {
        Color("indigo", bundle: .designSystem)
    }
    
    public static var yellow: Color {
        Color("yellow", bundle: .designSystem)
    }
    
    public static var purpleBackground: Color {
        Color("purpleBackground", bundle: .designSystem)
    }
    
    public static var purpleCheckedBackground: Color {
        Color("purpleCheckedBackground", bundle: .designSystem)
    }
    
    public static var grayUncheckedBackground: Color {
        Color("grayUncheckedBackground", bundle: .designSystem)
    }
    
    public static let purpleLightColor: Color = Color(red: 0.94, green: 0.93, blue: 0.99)
}
