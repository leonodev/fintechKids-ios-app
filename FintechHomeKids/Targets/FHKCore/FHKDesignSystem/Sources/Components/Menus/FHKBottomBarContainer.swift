//
//  FHKBottomBarContainer.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 15/5/26.
//

import SwiftUI

public struct FHKBottomBarContainer<Content: View>: View {
    public let items: [FHKMenuTabBar.Item]
    @Binding public var selectedIndex: Int
    public let onSelect: (FHKMenuTabBar.Item) -> Void
    public let floatingButton: Content
    
    public init(
        items: [FHKMenuTabBar.Item],
        selectedIndex: Binding<Int>,
        onSelect: @escaping (FHKMenuTabBar.Item) -> Void,
        @ViewBuilder floatingButton: () -> Content
    ) {
        self.items = Array(items.prefix(4))
        self._selectedIndex = selectedIndex
        self.onSelect = onSelect
        self.floatingButton = floatingButton()
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                tabGroup(for: 0..<2)
                
                Spacer()
                    .frame(width: FHKSize.size64)
                
                tabGroup(for: 2..<4)
            }
            .padding(.all, FHKSpace.space12)
            .background(FHKColor.wine)
            .cornerRadius(FHKSize.size24)
            .shadow(color: FHKColor.shadowColor, radius: FHKSize.size04, x: 0, y: FHKSize.size04)
            
            floatingButton
                .offset(y: -FHKSpace.space24)
        }
    }
    
    @ViewBuilder
    private func tabGroup(for range: Range<Int>) -> some View {
        ForEach(range, id: \.self) { index in
            if items.indices.contains(index) {
                let item = items[index]
                Button(action: {
                    if !item.isDisabled {
                        withAnimation(.spring()) { selectedIndex = index }
                        onSelect(item)
                    }
                }) {
                    VStack(spacing: FHKSpace.space04) {
                        item.icon
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: FHKSize.size24, height: FHKSize.size24)
                        
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
            } else {
                // Si el índice no existe (como en la preview), pintamos un espacio invisible
                // idéntico para mantener la simetría y el diseño visual intacto.
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct FHKBottomBarContainerPreview: View {
    @State private var selectedIndex = 0
    @State var isOpen: Bool = false
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
    
    let options: [FloatMenu.Option] = [
        .init(title: "members",
              image: .init(systemName: "person.crop.circle.badge.plus"),
              color: FHKColor.ultraPurple,
              menuType: .members,
              identifier: "members"),
        
            .init(title: "tasks",
                  image: .init(systemName: "house"),
                  color: FHKColor.indigo,
                  menuType: .tasks,
                  identifier: "tasks"),
        
            .init(title: "goals",
                  image: .init(systemName: "note.text.badge.plus"),
                  color: FHKColor.fuchsiaPink,
                  menuType: .goals,
                  identifier: "goals"),
        
            .init(title: "rewards",
                  image: .init(systemName: "gamecontroller"),
                  color: FHKColor.ultraPurple,
                  menuType: .rewards,
                  identifier: "rewards")
    ]
    
    var body: some View {
        VStack {
            Color.clear
                .safeAreaInset(edge: .bottom) {
                    ZStack {
                        VStack {
                            Spacer()
                            
                            FHKBottomBarContainer(items: items, selectedIndex: $selectedIndex) { item in
                                print("Click en \(item.title)")
                            } floatingButton: {
                                HStack {
                                    Spacer()
                                    
                                    FloatMenu(options: options, isOpen: $isOpen,
                                              callback: { menu in
                                    })
                                    
                                    Spacer()
                                }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    VStack {
        FHKBottomBarContainerPreview()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
