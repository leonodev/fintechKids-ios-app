//
//  FHKButtonCircle.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 2/12/25.
//

import SwiftUI

@MainActor
public protocol FHKButtonCircleProtocol: View {
    var logoImage: Image { get set }
    var appearance: FFHKButtonCircleAppearance { get set }
    var action: () -> Void { get }
}

public struct FHKButtonCircle: FHKButtonCircleProtocol {
    public var logoImage: Image
    public var appearance: FFHKButtonCircleAppearance
    public var action: () -> Void
    
    
    public init(logo: Image,
                size: FHKButtonComponent.Size = .large,
                style: FHKButtonComponent.Style = .filled,
                state: FHKButtonComponent.State = .enabled,
                mode: FHKButtonComponent.Mode = .glass(.clear),
                action: @escaping () -> Void = {})
    {
        logoImage = logo
        appearance = FFHKButtonCircleAppearance(size: size, style: style, state: state, mode: mode)
        self.action = action
        
    }
    
    public var body: some View {
        if case .glass(let glassVariant) = appearance.mode {
            if #available(iOS 26.0, *) {
                logoImage
                    .resizable()
                    .font(.system(size: 36))
                    .frame(width: appearance.sizeIcon, height: appearance.sizeIcon)
                    .glassEffect(appearance.modeGlass(variant: glassVariant))
                    .onTapGesture {
                        action()
                    }
            } else {
                // Fallback on earlier versions
                logoImage
                    .resizable()
                    .font(.system(size: 36))
                    .frame(width: appearance.sizeIcon, height: appearance.sizeIcon)
                    .onTapGesture {
                        action()
                    }
            }
        }
        else {
            logoImage
                .resizable()
                .font(.system(size: 36))
                .frame(width: appearance.sizeIcon, height: appearance.sizeIcon)
                .onTapGesture {
                    action()
                }
        }
    }
}


@MainActor
public struct FFHKButtonCircleAppearance {
    let size: FHKButtonComponent.Size
    let style: FHKButtonComponent.Style
    let state: FHKButtonComponent.State
    let mode: FHKButtonComponent.Mode
}


extension FFHKButtonCircleAppearance {
    
    var sizeIcon: CGFloat {
        switch self.size {
            case .small:
            return FHKSize.size32
        case .medium:
            return FHKSize.size40
        case .large:
            return FHKSize.size60
        }
    }
    
    @available(iOS 26.0, *)
    func modeGlass(variant: FHKButtonComponent.Mode.Style) -> Glass {
        switch variant {
        case .clear:
                .clear
            
        case .clearWithInteractive:
                .clear.interactive()
            
        case .regular:
                .regular
            
        case .regularWithInteractive:
                .regular.interactive()
        }
    }
}

#Preview {
    
    ZStack {
        
        HStack {
            FHKButtonCircle(logo: Image.englandCircleFlag,
                            mode: .glass(.regularWithInteractive))
            
            FHKButtonCircle(logo: Image.franceCircleFlag,
                            mode: .glass(.regularWithInteractive))
            
            FHKButtonCircle(logo: Image.italyCircleFlag,
                            mode: .glass(.regularWithInteractive))
            
            FHKButtonCircle(logo: Image.spainCircleFlag,
                            mode: .glass(.regularWithInteractive))
        }
        
    }
    
}
