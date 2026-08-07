//
//  FHKCheckBoxItem.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 12/4/26.
//

import SwiftUI

public struct FHKCheckBoxItem: Identifiable, Equatable {
    public let id = UUID()
    public let label: String
    public var isChecked: Bool
    
    public init(label: String, isChecked: Bool) {
        self.label = label
        self.isChecked = isChecked
    }
    
    public static func == (lhs: FHKCheckBoxItem, rhs: FHKCheckBoxItem) -> Bool {
        lhs.id == rhs.id && lhs.isChecked == rhs.isChecked
    }
}
