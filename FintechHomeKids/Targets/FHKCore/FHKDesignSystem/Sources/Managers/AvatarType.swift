//
//  AvatarType.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI

public enum AvatarType: String, CaseIterable {
    case boy_1
    case boy_2
    case boy_3
    case boy_4
    case boy_5
    case boy_6
    case boy_7
    case boy_8
    case boy_9
    case boy_disabled
    case girl_1
    case girl_2
    case girl_3
    case girl_4
    case girl_5
    case girl_6
    case girl_7
    case girl_8
    case girl_9

    public var image: Image {
        Image(self.rawValue, bundle: .module)
    }
    
    public var name: String {
        self.rawValue
    }
}

