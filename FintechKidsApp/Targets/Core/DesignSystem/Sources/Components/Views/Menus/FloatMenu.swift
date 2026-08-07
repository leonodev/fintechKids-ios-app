//
//  FloatMenu.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 20/1/26.
//

import SwiftUI
import Algorithms

public struct FloatMenu: View {
    public enum OptionType {
        case members
        case tasks
        case goals
        case rewards
    }
    
    public struct Option {
        var title: String
        var image: Image
        var color: Color
        var menuType: OptionType
        var identifier: String
        
        public init(title: String,
                    image: Image,
                    color: Color,
                    menuType: OptionType,
                    identifier: String
        ) {
            self.title = title
            self.image = image
            self.color = color
            self.menuType = menuType
            self.identifier = identifier
        }
    }
    
    let menuDiameter: Double = 180
    let options: [FloatMenu.Option]
    @Binding var isOpen: Bool
    let callback: (OptionType) -> Void
    
    public init(options: [FloatMenu.Option],
                isOpen: Binding<Bool>, // Cambiado a Binding para sincronizar con el contenedor si es necesario
                callback: @escaping (OptionType) -> Void
    ) {
        self.options = options
        self._isOpen = isOpen
        self.callback = callback
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.indigo).opacity(0.1)
                .frame(width: isOpen ? menuDiameter : 0)
                .offset(y: isOpen ? -FHKSpace.space12 : 0) 
            
            ForEach(options.indexed(), id: \.index) { index, option in
                button(option: option, atIndex: index)
                    .scaleEffect(isOpen ? 1 : 0.01)
                    .opacity(isOpen ? 1 : 0)
            }
            
            MainMenu(isOpen: $isOpen)
        }
    }
    
    func button(option: Option, atIndex index: Int) -> some View {
        let totalOptions = Double(options.count)
        
        // Dividimos 180 grados (π radianes) entre el número de espacios disponibles
        let step = totalOptions > 1 ? (.pi / (totalOptions - 1)) : 0
        
        // Forzamos a que empiece en -π (Izquierda exacta) y termine en 0 (Derecha exacta)
        let baseAngle = -.pi + (Double(index) * step)
        
        // Añadimos un pequeño efecto de torsión/rotación al abrir/cerrar para que sea dinámico
        let angle = baseAngle + (isOpen ? 0 : .pi * 0.15)
        
        // Hacemos que colapse al centro exacto (radio 0) cuando esté cerrado
        let radius = isOpen ? (menuDiameter / 2) : 0
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOpen = false
            }
            callback(option.menuType)
        }) {
            ZStack {
                Circle()
                    .foregroundColor(option.color)
                    .frame(width: 58, height: 58)
                    .shadow(color: FHKColor.shadowColor.opacity(0.3), radius: 4, x: 0, y: 2)
                
                VStack(spacing: 2) {
                    option.image
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                    
                    Text(option.title)
                        .foregroundColor(.white)
                        .font(.PangramSans.bold(FHKSize.size12))
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier(option.identifier)
        }
        .accessibilityIdentifier(option.identifier)
        .offset(x: cos(angle) * radius, y: sin(angle) * radius)
        .animation(.spring(response: 0.4, dampingFraction: 0.65), value: isOpen)
    }
}

public extension FloatMenu {
    struct MainMenu: View {
        @Binding var isOpen: Bool
        
        public var body: some View {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isOpen.toggle()
                }
            } label: {
                FHKButtomPlus(hasRoration: true, isOpen: $isOpen)
            }
        }
    }
}

#Preview {
    @Previewable @State var isOpen: Bool = false
    VStack {
        let options: [FloatMenu.Option] = [
            .init(title: "One",
                  image: .init(systemName: "person.crop.circle.badge.plus"),
                  color: .purple,
                  menuType: .members,
                  identifier: "One"),
            
            
                .init(title: "Two",
                      image: .init(systemName: "note.text.badge.plus"),
                      color: .pink,
                      menuType: .tasks,
                      identifier: "Two"),
            
                .init(title: "Three",
                      image: .init(systemName: "questionmark.circle.dashed"),
                      color: .gray,
                      menuType: .goals,
                      identifier: "Three"),
            
            
                .init(title: "Four",
                      image: .init(systemName: "questionmark.circle.dashed"),
                      color: .gray,
                      menuType: .rewards,
                      identifier: "Four")
        ]
        
        VStack {
            FloatMenu(options: options,
                      isOpen: $isOpen,
                      callback: { index in
                print(index)
            })
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
