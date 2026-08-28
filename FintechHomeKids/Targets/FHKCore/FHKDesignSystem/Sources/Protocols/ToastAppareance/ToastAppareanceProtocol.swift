//
//  ToastAppareanceProtocol.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

import SwiftUI

@MainActor
public protocol ToastAppareanceProtocol {
    var borderColor: Color { get }
    var fontText: Font { get }
    var cornerRadius: CGFloat { get }
    var borderWidth: CGFloat { get }
    var shadow: CGFloat { get }
}

public extension ToastAppareanceProtocol {
    var borderColor: Color {
        return FHKColor.gray
    }
    
    @MainActor
    var fontText: Font {
        return .PangramSans.medium(FHKSize.size20)
    }
    
    var cornerRadius: CGFloat {
        return CGFloat(FHKSize.size20)
    }
    
    var borderWidth: CGFloat {
        return CGFloat(1)
    }
    
    var shadow: CGFloat {
        return CGFloat(FHKSize.size04)
    }
}
