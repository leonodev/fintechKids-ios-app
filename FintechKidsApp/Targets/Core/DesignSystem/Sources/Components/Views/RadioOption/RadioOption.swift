//
//  RadioOption.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 14/3/26.
//

import SwiftUI

public struct FHKRadioOption<T: Equatable>: Identifiable {
    public let id = UUID()
    public let value: T
    public let label: String
    
    public init(value: T, label: String) {
        self.value = value
        self.label = label
    }
}

public struct FHKRadioGroupField<T: Equatable>: View {
    let title: String
    let options: [FHKRadioOption<T>]
    @Binding var selection: T?
    let onSelectionChanged: ((T) -> Void)?
    
    public init(
        title: String,
        options: [FHKRadioOption<T>],
        selection: Binding<T?>,
        onSelectionChanged: ((T) -> Void)? = nil
    ) {
        self.title = title
        self.options = options
        self._selection = selection
        self.onSelectionChanged = onSelectionChanged
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.basicWhite)
            
            VStack(spacing: 0) {
                ForEach(options) { option in
                    RadioButtonRow(option: option, selection: $selection) {
                        onSelectionChanged?(option.value)
                    }
                    
                    if option.id != options.last?.id {
                        Divider()
                            .padding(.horizontal, 15)
                    }
                }
            }
            .background(.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple, lineWidth: 1)
            )
        }
    }
    
    private struct RadioButtonRow: View {
        let option: FHKRadioOption<T>
        @Binding var selection: T?
        let action: () -> Void
        
        var isSelected: Bool {
            selection == option.value
        }
        
        var body: some View {
            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    selection = option.value
                    action()
                }
            }) {
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .stroke(isSelected ? Color.purple : Color.gray, lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Circle()
                                .fill(FHKColor.fuchsiaPink)
                                .frame(width: 12, height: 12)
                        }
                    }
                
                    Text(option.label)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    HStack {
        @State var selectedDuration: String? = nil
            
            let durationOptions = [
                FHKRadioOption(value: "days", label: "Días"),
                FHKRadioOption(value: "weeks", label: "Semanas"),
                FHKRadioOption(value: "months", label: "Meses")
            ]
        
        FHKRadioGroupField(
            title: "Tipo de Duración",
            options: durationOptions,
            selection: $selectedDuration,
            onSelectionChanged: { value in
                print("Se seleccionó: \(value)")
            }
        )
        .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
