//
//  FHKGoalCardView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 25/4/26.
//

import SwiftUI

public struct FHKGoalCardView: View {
    let id: Int
    let state: ComponentStateType
    let current: Double
    let total: Double
    let title: String
    let workType: String
    var action: (Int) -> Void
    
    public init(id: Int,
                state: ComponentStateType,
                current: Double,
                total: Double,
                title: String,
                workType: String,
                action: @escaping (Int) -> Void = { _ in }
    ) {
        self.id = id
        self.state = state
        self.current = current
        self.total = total
        self.title = title
        self.workType = workType
        self.action = action
    }
    
    public var body: some View {
        switch state {
        case .skeleton:
            skeletonView
            
        case .error(let error):
            errorView(msnError: error)
            
        case .loaded, .disabled:
            loadedView
        }
    }
    
    var loadedView: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space12) {
            HStack {
                circleIcon(systemName: "checkmark.circle.fill")
                Spacer()
                circleIcon(systemName: "trophy.fill")
            }
 
            Text(title)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(state == .loaded
                                 ? FHKColor.basicBlack.opacity(0.7)
                                 : FHKColor.gray.opacity(0.5)
                )
            
            // Barra de progreso y Valor faltante
            FHKProgressBarView(current: current,
                               total: total,
                               workType: workType,
                               isDisabled: state == .disabled)
        }
        .padding(FHKSpace.space16)
        .background(FHKColor.purpleLightColor)
        .cornerRadius(FHKSize.size24)
        .frame(width: 300)
        .onTapGesture {
            action(id)
        }
    }
    
    @ViewBuilder
    func errorView(msnError: String) -> some View {
        VStack(spacing: FHKSpace.space12) {
            Image(systemName: "xmark.icloud.fill")
                .font(.system(size: FHKSize.size48))
                .foregroundColor(.gray.opacity(0.6))

            Text(msnError)
                .font(.PangramSans.medium(FHKSize.size16))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(width: 268)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: FHKSize.size20)
                .fill(.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: FHKSize.size20)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: FHKSize.size20))
        
    }
    
    var skeletonView: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space12) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size32, height: FHKSize.size32)
                    .blinkCircleSkeleton()
                
                Spacer()
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size32, height: FHKSize.size32)
                    .blinkCircleSkeleton()
            }
        
            RoundedRectangle(cornerRadius: FHKSize.size04)
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size152, height: FHKSize.size16)
                .blinkTextSkeleton()
            
            // Barra de progreso y Valor faltante
            HStack(spacing: FHKSpace.space12) {
                // Barra de progreso personalizada
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: FHKSize.size12)
                            .blinkTextSkeleton()
                    }
                }
                .frame(height: FHKSize.size12)
                
                // Cálculo de lo que falta
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size52, height: FHKSize.size12)
                    .blinkTextSkeleton()
                    
            }
        }
        .padding(FHKSpace.space16)
        .cardBackgroundGlassStyle()
        .cornerRadius(FHKSize.size24)
        .frame(width: 300)
    }
    
    @ViewBuilder
    func circleIcon(systemName: String) -> some View {
        ZStack {
            Circle()
                .fill(state == .loaded
                      ? FHKColor.basicWhite.opacity(0.5)
                      : FHKColor.gray.opacity(0.5)
                )
                .frame(width: FHKSize.size32, height: FHKSize.size32)
            
            Image(systemName: systemName)
                .font(.PangramSans.bold(FHKSize.size20))
                .foregroundColor(state == .loaded
                                 ? FHKColor.purpleBackground.opacity(0.7)
                                 : FHKColor.gray
                )
        }
    }
}

public extension FHKGoalCardView {
    @ViewBuilder
    public static func skeletons(count: Int) -> some View {
        ForEach(0..<count, id: \.self) { _ in
            FHKGoalCardView(id: 0,
                            state: .skeleton,
                            current: 0,
                            total: 0,
                            title: "",
                            workType: "")
        }
    }
    
    @ViewBuilder
    public static func error(msn: String) -> some View {
        FHKGoalCardView(id: 0,
                        state: .error(msn),
                        current: 0,
                        total: 0,
                        title: "",
                        workType: "")
    }
}

#Preview {
    PreviewContainer {
        VStack(spacing: 20) {
            FHKGoalCardView.skeletons(count: 1)
        
            FHKGoalCardView(
                id: 2,
                state: .loaded,
                current: 2,
                total: 5,
                title: "Read a Book",
                workType: "Hours"
            )
            
            FHKGoalCardView(
                id: 3,
                state: .disabled,
                current: 3,
                total: 5,
                title: "Read a Book",
                workType: "Hours"
            )
            
            FHKGoalCardView.error(msn: "Don't have data for this goal yet.")
        }
        .padding()
    }
}
