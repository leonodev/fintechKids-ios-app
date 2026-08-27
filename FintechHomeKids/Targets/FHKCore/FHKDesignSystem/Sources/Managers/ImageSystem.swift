//
//  ImageSystem.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 21/2/26.
//

import SwiftUI

public enum ImageSystem: String {
    case trash = "trash"
    case star_fill = "star.fill"
    
    public var name: String {
        return self.rawValue
    }
}
