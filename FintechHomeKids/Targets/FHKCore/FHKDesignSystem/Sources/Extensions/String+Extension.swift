//
//  String+Extension.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 24/1/26.
//

import SwiftUI

public extension String {
    
    var getAvatar: Image {
        Image(self, bundle: .module)
    }
}
