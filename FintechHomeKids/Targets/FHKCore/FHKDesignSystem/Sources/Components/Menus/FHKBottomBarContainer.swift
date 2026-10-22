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
    
    private var hasFloatingButton: Bool {
        !(Content.self is EmptyView.Type)
    }
    
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
                if hasFloatingButton {
                    
                    tabGroup(for: 0..<2)
                    
                    Spacer()
                        .frame(width: FHKSize.size64)
                    
                    tabGroup(for: 2..<4)
                } else {
                    tabGroup(for: 0..<items.count)
                }
            }
            .padding(.all, FHKSpace.space12)
            .background(FHKColor.stone)
            .cornerRadius(FHKSize.size24)
            .shadow(color: FHKColor.shadowColor, radius: FHKSize.size04, x: 0, y: FHKSize.size04)
            
            if hasFloatingButton {
                floatingButton
                    .offset(y: -FHKSpace.space60)
            }
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
                    VStack(spacing: 0) {
                        item.icon
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: FHKSize.size72,
                                   height: FHKSize.size72)
                        
                        Text(item.title)
                            .font((selectedIndex == index)
                                   ? .PangramSans.bold(FHKSize.size14)
                                   : .PangramSans.medium(FHKSize.size12))
                                  
                            .foregroundColor(
                                item.isDisabled
                                ? FHKColor.gray
                                : FHKColor.basicBlack
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(item.isDisabled)
            } else {
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

// Initializer para cuando NO se proporciona el floatingButton
extension FHKBottomBarContainer where Content == EmptyView {
    public init(
        items: [FHKMenuTabBar.Item],
        selectedIndex: Binding<Int>,
        onSelect: @escaping (FHKMenuTabBar.Item) -> Void
    ) {
        self.items = Array(items.prefix(4))
        self._selectedIndex = selectedIndex
        self.onSelect = onSelect
        self.floatingButton = EmptyView()
    }
}

// MARK: - Previews
struct FHKBottomBarContainerPreview: View {
    @State private var selectedIndex = 0
    @State var isOpen: Bool = false
    let items: [FHKMenuTabBar.Item] = [
        .init(title: "Payments",
              activeIcon: .loansEnable,
              lockedIcon: .loansDisabled),
        
        .init(title: "Transfer",
              activeIcon: .transferMemberEnable,
              lockedIcon: .transferMemberDisable),
        
        .init(title: "Loans",
              activeIcon: .loansEnable,
              lockedIcon: .loansDisabled),
        
        .init(title: "Saving",
              activeIcon: .savingsEnable,
              lockedIcon: .savingsDisabled,
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
        VStack(spacing: 40) {
            // OPCIÓN 1: SIN Floating Button
            FHKBottomBarContainer(items: items, selectedIndex: $selectedIndex) { item in
                print("Click en \(item.title)")
            }
            
            // OPCIÓN 2: CON Floating Button
            FHKBottomBarContainer(items: items, selectedIndex: $selectedIndex) { item in
                print("Click en \(item.title)")
            } floatingButton: {
                FloatMenu(options: options, isOpen: $isOpen, callback: { _ in })
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
