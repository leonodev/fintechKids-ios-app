//
//  FHKMenuTabBar.swift
//  FHKDesignSystem
//
//  Created by AI on 2026-05-14.
//

import SwiftUI

public struct FHKMenuTabBar: View {
    public struct Item: Identifiable {
        public let id = UUID()
        public let title: String
        private let activeIcon: Image
        private let lockedIcon: Image
        public var isDisabled: Bool
        
        public var icon: Image {
            isDisabled ? lockedIcon : activeIcon
        }
        
        public init(title: String, activeIcon: Image, lockedIcon: Image, isDisabled: Bool = false) {
            self.title = title
            self.activeIcon = activeIcon
            self.lockedIcon = lockedIcon
            self.isDisabled = isDisabled
        }
    }
    
    public let items: [Item]
    public let onSelect: (Item) -> Void
    @Binding public var selectedIndex: Int
    
    public init(items: [Item], selectedIndex: Binding<Int>, onSelect: @escaping (Item) -> Void) {
        self.items = Array(items.prefix(5)) // Supports up to 5 items
        self._selectedIndex = selectedIndex
        self.onSelect = onSelect
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: {
                    if !item.isDisabled {
                        withAnimation(.spring()) {
                            selectedIndex = index
                        }
                        onSelect(item)
                    }
                }) {
                    VStack(spacing: FHKSpace.space04) {
                        item.icon
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: FHKSize.size36,
                                   height: FHKSize.size36)
                        
                        Text(item.title)
                            .font(.PangramSans.medium(FHKSize.size12))
                            .foregroundColor(
                                item.isDisabled ? FHKColor.gray :
                                    (selectedIndex == index ? FHKColor.basicWhite : FHKColor.lunarSand)
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(item.isDisabled)
            }
        }
        .padding(.vertical, FHKSpace.space16)
        .background(FHKColor.wine.opacity(0.3))
        .cornerRadius(FHKSize.size04)
        .shadow(color: FHKColor.shadowColor,
                radius: FHKSize.size04,
                x: 0,
                y: FHKSize.size04)
    }
}

struct FHKMenuTabBarPreview: View {
    @State private var selectedIndex = 0
    let items: [FHKMenuTabBar.Item] = [
        .init(title: "Payments",
              activeIcon: .menuLoansEnable,
              lockedIcon: .menuLoansDisabled),
        
        .init(title: "Transfer",
              activeIcon: .menuTransferEnable,
              lockedIcon: .menuTransferDisabled),
        
        .init(title: "Loans",
              activeIcon: .menuLoansEnable,
              lockedIcon: .menuLoansDisabled),
        
        .init(title: "Saving",
              activeIcon: .menuSavingsEnable,
              lockedIcon: .menuSavingsDisabled,
              isDisabled: true)
    ]
    
    var body: some View {
        Color.clear
            .safeAreaInset(edge: .bottom) {
                FHKMenuTabBar(items: items, selectedIndex: $selectedIndex) { item in
                    print("Selected \(item.title)")
                }
                .padding(.bottom, -FHKSpace.space32)
            }
    }
}

#Preview {
    VStack {
        FHKMenuTabBarPreview()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
