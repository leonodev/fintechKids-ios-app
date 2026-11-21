//
//  FHKServiceUnavailableView.swift
//  FintechHomeKids
//

import SwiftUI

public struct ServiceUnavailableView: View {
    @State private var isRetrying = false
    
    private let title: String
    private let message: String
    private let onRetry: @Sendable () async -> Void
    
    public init(
        title: String = "title_service_temporarily_unavailable",
        message: String = "title_we_could_not_verify_status",
        onRetry: @escaping @Sendable () async -> Void
    ) {
        self.title = title
        self.message = message
        self.onRetry = onRetry
    }
    
    public var body: some View {
        VStack(spacing: FHKSize.size24) {
            Spacer()
            
            // Icono de bloqueo / servidor no disponible
            ZStack {
                Circle()
                    .fill(FHKColor.fuchsiaPink.opacity(0.14))
                    .frame(width: FHKSize.size104, height: FHKSize.size104)
                
                Image(systemName: "icloud.slash.fill")
                    .font(.system(size: FHKSize.size44, weight: .semibold))
                    .foregroundStyle(FHKColor.fuchsiaPink)
            }
            
            VStack(spacing: FHKSpace.space12) {
                Text(title.localized)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                
                Text(message.localized)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, FHKSpace.space12)
            }
            
            Spacer()
            
            Button {
                guard !isRetrying else { return }
                isRetrying = true
                Task {
                    await onRetry()
                    isRetrying = false
                }
            } label: {
                HStack(spacing: FHKSize.size12) {
                    if isRetrying {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                    Text(isRetrying
                         ? "title_checking".localized
                         : "title_try_again".localized)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, FHKSize.size16)
            }
            .buttonStyle(.borderedProminent)
            .tint(FHKColor.fuchsiaPink)
            .disabled(isRetrying)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(FHKSize.size24)
        .interactiveDismissDisabled(true)
    }
}

#Preview {
    ServiceUnavailableView {
        try? await Task.sleep(for: .seconds(2))
    }
}
