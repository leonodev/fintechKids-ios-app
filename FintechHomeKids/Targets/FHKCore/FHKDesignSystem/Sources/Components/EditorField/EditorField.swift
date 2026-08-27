//
//  EditorField.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 14/3/26.
//

import SwiftUI

public struct FHKEditorField: View {
    @Binding var text: String
    var maxLength: Int
    
    public init(text: Binding<String>, maxLength: Int = 100) {
        self._text = text
        self.maxLength = maxLength
    }
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .padding(FHKSize.size08)
                .frame(height: FHKSize.size120)
                .background(Color.purple.opacity(0.05))
                .foregroundColor(FHKColor.lunarSand)
                .cornerRadius(FHKSize.size12)
                .overlay(
                    RoundedRectangle(cornerRadius: FHKSize.size12)
                        .stroke(Color.purple, lineWidth: 1)
                )
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }
            
            Text("\(text.count)/\(maxLength)")
                .font(.caption)
                .foregroundColor(text.count >= maxLength ? FHKColor.error : FHKColor.lunarSand)
        }
    }
}

#Preview {
    @Previewable @State var sampleText: String = "Lavar los platos"
    VStack {
        FHKEditorField(text: $sampleText, maxLength: 120)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
