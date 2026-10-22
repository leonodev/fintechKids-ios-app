//
//  RewardCard.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/10/26.
//

import SwiftUI

public extension LinearGradient {
    
    static let cardBlue = LinearGradient(
        colors: [Color.blue, Color.cyan],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardYellow = LinearGradient(
        colors: [Color.orange, Color.yellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

public struct RewardCardView: View {
    let id: Int
    let state: FHKComponentStateType
    let title: String
    let bgGradient: LinearGradient
    var action: (Int) -> Void
    
    public init(id: Int,
                state: FHKComponentStateType,
                title: String,
                bgGradient: LinearGradient = .cardBlue,
                action: @escaping (Int) -> Void = { _ in }
    ) {
        self.id = id
        self.state = state
        self.title = title
        self.bgGradient = bgGradient
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
        VStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: FHKSpace.space16, style: .continuous)
                    .fill(state == .loaded
                          ? Color.blue.opacity(0.1)
                          : FHKColor.gray.opacity(0.5))
                    .frame(width: FHKSize.size60, height: FHKSize.size60)
                
                Image(systemName: "scooter")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(state == .loaded
                                     ? Color.blue
                                     : FHKColor.gray.opacity(0.5))
                    .frame(width: FHKSize.size48, height: FHKSize.size48)
            }
            Spacer()
            
            Text(title)
                .font(.PangramSans.bold(FHKSize.size20))
                .multilineTextAlignment(.center)
                .foregroundColor(state == .loaded
                                 ? FHKColor.basicBlack
                                 : FHKColor.gray.opacity(0.5)
                )
            
            HStack {
                circleIcon(systemName: "trophy.fill")
                
                Text(title)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(state == .loaded
                                     ? FHKColor.basicBlack.opacity(0.7)
                                     : FHKColor.gray.opacity(0.5)
                    )
            }    
        }
        .padding(FHKSpace.space16)
        .background(bgGradient)
        .cornerRadius(FHKSize.size24)
        .frame(maxWidth: FHKSize.size200)
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
                .multilineTextAlignment(.center)
                .font(.PangramSans.medium(FHKSize.size16))
                .foregroundColor(.white.opacity(0.4))
        }
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
        .frame(maxWidth: FHKSize.size200)
        
    }
    
    var skeletonView: some View {
        VStack(alignment: .center, spacing: FHKSpace.space12) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size72, height: FHKSize.size72)
                .blinkCircleSkeleton()
        
            RoundedRectangle(cornerRadius: FHKSize.size04)
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size96, height: FHKSize.size16)
                .blinkTextSkeleton()
                .padding(.top, 8)
            
            HStack {
                
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size48, height: FHKSize.size16)
                    .blinkTextSkeleton()
                
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size96, height: FHKSize.size16)
                    .blinkTextSkeleton()
            }
            .padding(.top, 8)
            
            RoundedRectangle(cornerRadius: FHKSize.size04)
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size128, height: FHKSize.size16)
                .blinkTextSkeleton()
                .padding(.top, 8)
            
        }
        .padding(FHKSpace.space16)
        .cardBackgroundGlassStyle()
        .cornerRadius(FHKSize.size24)
        .frame(maxWidth: FHKSize.size200)
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

public extension RewardCardView {
    @ViewBuilder
    static func skeletons(count: Int) -> some View {
        ForEach(0..<count, id: \.self) { _ in
            RewardCardView(id: 0,
                           state: .skeleton,
                           title: "")
        }
    }
    
    @ViewBuilder
    static func error(msn: String) -> some View {
        RewardCardView(id: 0,
                       state: .error(msn),
                       title: "")
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            RewardCardView(
                id: 0,
                state: .skeleton,
                title: ""
            )
            
            RewardCardView(
                id: 2,
                state: .loaded,
                title: "Read a Book",
                bgGradient: .cardBlue,
            )
            
            RewardCardView(
                id: 3,
                state: .disabled,
                title: "Read a Book"
            )
            
            RewardCardView(
                id: 0,
                state: .error("Don't have data for this goal yet."),
                title: ""
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .background(FHKColor.indigo)
}
