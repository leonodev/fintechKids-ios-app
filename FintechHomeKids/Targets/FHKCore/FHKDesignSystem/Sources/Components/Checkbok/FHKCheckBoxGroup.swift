//
//  FHKCheckBoxGroup.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 12/4/26.
//

import SwiftUI

public struct FHKCheckBoxGroup: View {
    public let title: String?
    @Binding public var items: [FHKCheckBoxItem]
    
    public init(title: String?, items: Binding<[FHKCheckBoxItem]>) {
        self.title = title
        self._items = items
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space16) {
            if let title = title {
                Text(title)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(FHKColor.basicWhite)
            }
            
            VStack(spacing: FHKSpace.space12) {
                ForEach($items) { $item in
                    FHKCheckBox(label: item.label, isChecked: $item.isChecked)
                }
            }
        }
    }
}

struct CheckBoxGroupWrapper: View {
    @State private var items = [
        FHKCheckBoxItem(label: "je suis d'accord", isChecked: false),
        FHKCheckBoxItem(label: "i agree and wish to continue", isChecked: true),
        FHKCheckBoxItem(label: "sono d'accordo", isChecked: false)
    ]
    
    // Devuelve el array de objetos que están marcados
    var selectedItems: [FHKCheckBoxItem] {
        items.filter { $0.isChecked }
    }

    // Devuelve solo los textos (labels) de los marcados, útil para enviarlo a una API
    var selectedLabels: [String] {
        items.filter { $0.isChecked }.map { $0.label }
    }

    // Para saber si al menos uno está seleccionado (para habilitar un botón, por ejemplo)
    var hasSelection: Bool {
        items.contains { $0.isChecked }
    }
    
    var body: some View {
        FHKCheckBoxGroup(
            title: "selecciona tus preferencias:",
            items: $items
        )
        .padding()
        
        Button(action: {
            // Aquí usas los datos
            print("metas seleccionadas: \(selectedLabels)")
        }) {
                Text("continuar")
                    .padding()
                    .background(hasSelection ? Color.white : Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .disabled(!hasSelection)
    }
}

#Preview("Grupo de CheckBoxes") {
    VStack {
        CheckBoxGroupWrapper()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
