//
//  FHKMemberItem.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 24/2/26.
//

import SwiftUI

public struct FHKMemberItem: View {
    let id: UUID
    let avatarName: String
    let nameMember: String
    let state: FHKComponentStateType
    var action: (UUID) -> Void
    
    @State private var isPulsing = false

    public init(id: UUID = UUID(),
                avatarName: String = "",
                nameMember: String = "",
                state: FHKComponentStateType = .skeleton,
                action: @escaping (UUID) -> Void = { _ in }
    ) {
        self.id = id
        self.avatarName = avatarName
        self.nameMember = nameMember
        self.state = state
        self.action = action
    }
    
    public var body: some View {
        content
            .animation(.easeInOut(duration: 0.3), value: state)
    }
    
    @ViewBuilder
    private var content: some View {
        switch state {
        case .skeleton:
            skeletonView
            
        case .error(let error):
            errorView(msnError: error)
            
        case .loaded, .disabled:
            loadedView
        }
    }
}

// MARK: - Subviews
private extension FHKMemberItem {
    
    var loadedView: some View {
        VStack(spacing: FHKSpace.space12) {
            AvatarView(image: state == .loaded
                       ? avatarName.getAvatar
                       : AvatarType.boy_disabled.image,
                       size: FHKSize.size68)
            .clipShape(Circle())
            .if(state == .loaded, transform: { view in
                view.overlay(Circle().stroke(Color.yellow.opacity(0.9), lineWidth: 2))
                    .onTapGesture {
                        action(id)
                    }
            }, else: { view in
                view.overlay(Circle().stroke(FHKColor.gray.opacity(0.4), lineWidth: 1))
            })
                

            Text(nameMember.capitalized)
                .font(.PangramSans.medium(FHKSize.size16))
                .foregroundColor(state == .loaded
                                 ? FHKColor.basicWhite
                                 : FHKColor.gray.opacity(0.4))
                .padding(.leading, FHKSize.size04)
        }
    }
    
    var skeletonView: some View {
        VStack(spacing: FHKSpace.space12) {
            // Representación del Avatar
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size68, height: FHKSize.size68)
                .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))

            // Representación del Texto
            RoundedRectangle(cornerRadius: FHKSize.size04)
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size60, height: FHKSize.size16)
        }
        .opacity(isPulsing ? 0.5 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
    
    @ViewBuilder
    func errorView(msnError: String) -> some View {
        VStack(spacing: FHKSpace.space12) {
            Image(systemName: "person.crop.circle.badge.exclam")
                .font(.system(size: FHKSize.size48))
                .foregroundColor(.gray.opacity(0.6))

            Text(msnError)
                .font(.PangramSans.medium(FHKSize.size16))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(width: FHKSize.size80) // Para mantener un ancho similar al avatar
    }
}

extension FHKMemberItem {
    /// Genera una vista con el número de esqueletos deseado.
    @ViewBuilder
    public static func skeletons(count: Int = 3) -> some View {
        HStack(spacing: FHKSpace.space16) {
            ForEach(0..<count, id: \.self) { _ in
                FHKMemberItem(
                    state: .skeleton,
                    action: { _ in }
                )
            }
        }
    }
}

#Preview {
    VStack {
        
        Group {
            FHKMemberItem(id: UUID(),
                          avatarName: AvatarType.boy_1.name,
                          nameMember: "Juan",
                          state: .disabled,
                          action: { _ in })
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
