//
//  SwiftUIView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 22/11/25.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        ZStack(alignment: .leading) {
            // Contenido principal
            Color(.systemBackground)
                .ignoresSafeArea()
            
            EnvironmentView()
        }
    }
}

public struct EnvironmentView: View {
    
    public init() {}
    
    public var body: some View {
        VStack {
        #if DEBUG
            Text("Develop")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .fixedSize()
                .rotationEffect(.degrees(-90))
                .frame(width: 28)
                .padding(.vertical, 40)
                .background(
                    ZStack {
                        // Fondo con gradiente pink y purple
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [.pink.opacity(0.4), .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blur(radius: 0.5)
                        
                        // Borde sutil - En gris y verde (como querías antes)
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(LinearGradient(
                                colors: [.gray.opacity(0.4), .green],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 2, y: 2)
                )
                .padding(.leading, 0)
            
            Spacer()
        #else
            EmptyView()
        #endif
        }
        .offset(x: -5)
    }
}

#Preview {
    ContentView()
}
