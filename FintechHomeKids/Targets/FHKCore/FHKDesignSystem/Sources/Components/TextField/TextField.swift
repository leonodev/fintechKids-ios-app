//
//  GradientBorderField.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 7/1/26.
//

import SwiftUI

public struct FHKTextField: View {
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var keyboardType: UIKeyboardType
    var identifier: String
    
    @State private var isTextVisible: Bool = false
    @FocusState private var isFocused: Bool
    
    public init(text: Binding<String>,
                placeholder: String,
                isSecure: Bool = false,
                keyboardType: UIKeyboardType = .default,
                identifier: String = ""
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.identifier = identifier
        self._isTextVisible = State(initialValue: !isSecure)
    }
    
    private var accentGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [FHKColor.ultraPurple, FHKColor.fuchsiaPink]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // Lógica para determinar si el label debe flotar
    private var isFloating: Bool {
        !text.isEmpty
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            // Borde con degradado
            RoundedRectangle(cornerRadius: 12)
                .stroke(accentGradient, lineWidth: 2)
            
            // Placeholder Animado (Floating Label)
            Text(placeholder)
                .font(.PangramSans.bold(isFloating ? FHKSize.size12 : FHKSize.size20))
                .foregroundColor(FHKColor.lunarSand.opacity(isFloating ? 1.0 : 0.4))
                .padding(.horizontal, isFloating ? 8 : 0) // Añadimos un poco de "aire" a los lados
                .background {
                    if isFloating {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(FHKColor.ultraPurple)
                    }
                }
                .offset(x: isFloating ? 12 : 16, y: isFloating ? -28 : 0) // Volvemos a -28 para que "pise" la línea
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isFloating)
                .allowsHitTesting(false)
            
            HStack(spacing: 12) {
                Group {
                    if isTextVisible {
                        TextField("", text: $text)
                            .keyboardType(keyboardType)
                            .focused($isFocused)
                            .autocapitalization(.none)
                            .font(.PangramSans.bold(FHKSize.size20))
                            .foregroundColor(FHKColor.lunarSand)
                            .accessibilityIdentifier(identifier)
                    } else {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .font(.PangramSans.bold(FHKSize.size20))
                            .foregroundColor(FHKColor.lunarSand)
                            .accessibilityIdentifier(identifier)
                    }
                }
                .padding(.top, isFloating ? 8 : 0)
                
                if isSecure {
                    Button(action: { isTextVisible.toggle() }) {
                        Image(systemName: isTextVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(FHKColor.lunarSand.opacity(0.7))
                            .font(.system(size: 18))
                    }
                }
            }
            .padding(.horizontal, FHKSize.size16)
        }
        .frame(height: FHKSize.size56)
        .onChange(of: text) { oldvalue, newValue in
            if keyboardType == .numberPad {
                let filtered = newValue.filter { $0.isNumber }
                if filtered != newValue {
                    text = filtered
                }
            }
        }
        .toolbar {
            if isFocused && keyboardType == .numberPad {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("OK") {
                        isFocused = false
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        FHKTextField(
            text: .constant("password"),
            placeholder: "Introduce tu contraseña",
            isSecure: true,
            keyboardType: .numberPad
        )
        Spacer()
    }
    .padding()
    .background(FHKColor.indigo.opacity(0.9))
    
}

