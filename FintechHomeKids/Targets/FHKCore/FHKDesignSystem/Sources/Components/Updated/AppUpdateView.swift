//
//  AppUpdateView.swift
//  FintechHomeKids
//

import SwiftUI
import FHKCore

public struct AppUpdateView: View {
    @Environment(\.openURL) private var openURL
    
    private let state: VersionAppState
    private let latestVersion: String
    private let releaseNotes: String?
    private let storeUrl: String?
    private let onContinueWithoutUpdating: (() -> Void)?
    
    public init(
        state: VersionAppState,
        latestVersion: String,
        releaseNotes: String? = nil,
        storeUrl: String? = nil,
        onContinueWithoutUpdating: (() -> Void)? = nil
    ) {
        self.state = state
        self.latestVersion = latestVersion
        self.releaseNotes = releaseNotes
        self.storeUrl = storeUrl
        self.onContinueWithoutUpdating = onContinueWithoutUpdating
    }
    
    private var isRequired: Bool {
        state == .requiredUpdate
    }
    
    public var body: some View {
        VStack(spacing: FHKSpace.space24) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(isRequired ? Color.red.opacity(0.12) : Color.purple.opacity(0.12))
                    .frame(width: FHKSize.size100, height: FHKSize.size100)
                
                Image(systemName: isRequired ? "exclamationmark.triangle.fill" : "arrow.down.app.fill")
                    .font(.system(size: FHKSize.size44, weight: .semibold))
                    .foregroundStyle(isRequired ? Color.red : Color.purple)
            }
            
            // Title y subtítle
            VStack(spacing: FHKSpace.space12) {
                Text(isRequired
                     ? "title_update_required".localized
                     : "title_new_version_available".localized)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                
                Text("title_version".localized + " \(latestVersion)")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, FHKSpace.space12)
                    .padding(.vertical, FHKSpace.space04)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(Capsule())
                    .padding(.bottom, FHKSpace.space16)
                
                Text(
                    isRequired
                    ? "title_to_keep_using".localized
                    : "title_a_new_version".localized
                )
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, FHKSpace.space08)
            }
            
            // Notas de la versión (si el backend envía releaseNotes)
            if let releaseNotes, !releaseNotes.isEmpty {
                VStack(alignment: .leading, spacing: FHKSpace.space08) {
                    Text("title_what_is_new".localized)
                        .font(.PangramSans.bold(FHKSize.size16))
                        .foregroundStyle(FHKColor.indigo)
                        .textCase(.uppercase)
                    
                    Text(releaseNotes)
                        .font(.PangramSans.semibold(FHKSize.size14))
                        .foregroundStyle(FHKColor.indigo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(FHKSpace.space16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            
            Spacer()
            
            // Buttons actions
            VStack(spacing: FHKSpace.space12) {
                Button {
                    if let storeUrl, let url = URL(string: storeUrl) {
                        openURL(url)
                    }
                } label: {
                    Text("title_update_now".localized)
                        .font(.PangramSans.semibold(FHKSize.size20))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, FHKSpace.space16)
                }
                .buttonStyle(.borderedProminent)
                .tint(isRequired ? .red : .purple)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                
                // Solo se muestra si la actualización es recomendada (no obligatoria)
                if !isRequired {
                    Button {
                        onContinueWithoutUpdating?()
                    } label: {
                        Text("title_maybe_later".localized)
                            .font(.PangramSans.semibold(FHKSize.size16))
                            .foregroundStyle(FHKColor.indigo)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, FHKSpace.space12)
                    }
                }
            }
        }
        .padding(FHKSpace.space24)
        // Prevents closing the view by swiping down if it is mandatory
        .interactiveDismissDisabled(isRequired)
    }
}

#Preview("Required Update") {
    AppUpdateView(
        state: .requiredUpdate,
        latestVersion: "1.2.0",
        releaseNotes: "Critical security improvements and new reward tracking features.",
        storeUrl: "https://apps.apple.com/app/id000000000"
    )
}

#Preview("Recommended Update") {
    AppUpdateView(
        state: .recommendedUpdate,
        latestVersion: "1.2.0",
        releaseNotes: "Performance improvements and new animations.",
        storeUrl: "https://apps.apple.com/app/id000000000",
        onContinueWithoutUpdating: {
            print("User tapped Maybe Later")
        }
    )
}
