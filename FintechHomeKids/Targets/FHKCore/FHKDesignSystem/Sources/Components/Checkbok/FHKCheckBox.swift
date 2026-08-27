//
//  FHKCheckBox.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 11/4/26.
//

import SwiftUI

// MARK: - FHKCheckBox Component
public struct FHKCheckBox: View {
    public let label: String
    @Binding public var isChecked: Bool
    
    public init(label: String, isChecked: Binding<Bool>) {
        self.label = label
        self._isChecked = isChecked
    }
    
    private let checkBoxSize: CGFloat = 24
    private let cornerRadius: CGFloat = 8
    
    public var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isChecked ? FHKColor.purpleCheckedBackground : FHKColor.grayUncheckedBackground)
                        .frame(width: checkBoxSize, height: checkBoxSize)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(FHKColor.gray, lineWidth: isChecked ? 0 : 2)
                        )
 
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(FHKColor.gray)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Text(label)
                    .font(.PangramSans.extraboldItalic(FHKSize.size16))
                    .foregroundColor(FHKColor.lunarSand)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Estados de CheckBox") {
    
    VStack(alignment: .leading, spacing: 20) {
        // Estado Desmarcado
        FHKCheckBox(
            label: "opción desmarcada",
            isChecked: .constant(false)
        )
        
        // Estado Marcado
        FHKCheckBox(
            label: "opción marcada",
            isChecked: .constant(true)
        )
    }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FHKColor.indigo)
    
}
