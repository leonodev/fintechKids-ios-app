//
//  FHKButtomPlus.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 19/4/26.
//

import SwiftUI

public struct FHKButtomPlus: View {
    private var hasRoration: Bool
    @Binding private var isOpen: Bool
    
    public init (hasRoration: Bool = false,
                 isOpen: Binding<Bool> = .constant(false)
    ) {
        self.hasRoration = hasRoration
        self._isOpen = isOpen
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.indigo)
                .frame(width: FHKSize.size72, height: FHKSize.size72)
                .shadow(radius: 5)
            
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title)
                .if(hasRoration) { view in
                    view.rotationEffect(isOpen
                                        ? .degrees(45)
                                        : .degrees(0))
                }
                
        }
    }
}
