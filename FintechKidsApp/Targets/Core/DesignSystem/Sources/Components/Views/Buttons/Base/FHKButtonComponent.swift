//
//  FHKButtonComponent.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 24/11/25.
//

import SwiftUI

public enum FHKButtonComponent {
    
    public enum Types {
        case primary
        case secondary
        case terciary
    }
    
    public enum Style {
        case filled
        case outlined
    }
    
    public enum State {
        case enabled
        case disabled
        case skeleton
    }
    
    public enum Variant {
        case simple          // Solo texto
        case withIcon        // Texto + ícono
        case withSubtitle    // Título + subtítulo
        case detailed        // Título + subtítulo + metadata
    }
    
    public enum Position {
        case left
        case right
        case none
    }
    
    public enum Mode {
        case glass(Style)
        case solid
        
        public enum Style {
            case clear
            case clearWithInteractive
            case regular
            case regularWithInteractive
        }
    }
    
    public enum Size {
        case small
        case medium
        case large
    }
}
