//
//  StarCoinView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 21/1/26.
//
import SwiftUI

public struct StarCoinView: View {
    var text: String
    var textError: String
    var balance: String
    var state: ComponentState
    @State private var isPulsing = false

    public init(text: String,
                textError: String,
                balance: String,
                state: ComponentState = .loaded
    ) {
        self.text = text
        self.textError = textError
        self.balance = balance
        self.state = state
    }
    
    public var body: some View {
        content
            .padding(.vertical, FHKSize.size12)
            .padding(.horizontal, FHKSize.size20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(state == .skeleton ? Color.gray.opacity(0.2) : FHKColor.indigo)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                }
            )
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .animation(.easeInOut(duration: 0.3), value: state)
    }
    
    @ViewBuilder
    private var content: some View {
        switch state {
        case .skeleton:
            skeletonView
            
        case .error:
            errorView
            
        case .loaded:
            loadedView
        }
    }
}

// MARK: - Subviews
private extension StarCoinView {
    
    var loadedView: some View {
        HStack(spacing: FHKSize.size12) {
            Image(systemName: "star.fill")
                .foregroundColor(FHKColor.yellow)
                .font(.system(size: FHKSize.size28, weight: .bold))
            
            HStack(spacing: FHKSpace.space04) {
                Text(text)
                    .font(.PangramSans.bold(FHKSize.size16))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(balance)
                    .font(.system(size: FHKSize.size20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    var skeletonView: some View {
        HStack(spacing: FHKSize.size12) {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: FHKSize.size28, height: FHKSize.size28)
            
            VStack(alignment: .leading, spacing: FHKSpace.space04) {
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size100, height: FHKSize.size12)
                
                RoundedRectangle(cornerRadius: FHKSize.size04)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: FHKSize.size52, height: FHKSize.size16)
            }
        }
        .opacity(isPulsing ? 0.5 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
    
    var errorView: some View {
        HStack(spacing: FHKSize.size12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow.opacity(0.6))
            
            Text(textError)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.vertical, FHKSpace.space04)
    }
}

#Preview {
    VStack {
        StarCoinView(text: "StarCoins",
                     textError: "Not Available",
                     balance: "1.250",
                     state: .loaded)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(FHKColor.indigo)
}
