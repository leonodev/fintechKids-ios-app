//
//  FHKValidatePinModalView.swift
//  fintechKids
//
//  Created by Fredy Leon on 20/4/26.
//

import SwiftUI
import FHKDesignSystem

struct FHKValidatePinModalView: View {
    @Bindable var viewModel: FHKTaskStartScreenVM

    var body: some View {
        VStack(alignment: .leading, spacing: FHKSpace.space08) {
            Text(viewModel.viewState.titleValidatePinApprove)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.lunarSand)
                .padding(.bottom, FHKSpace.space16)
            
            FHKTextField(
                text: $viewModel.viewState.approvePIN,
                placeholder: viewModel.viewState.pinApproveTaskPlaceholder,
                isSecure: true
            )
            .padding(.bottom, FHKSpace.space32)
            
            FHKButtonPrimary(
                title: viewModel.viewState.titleButtonContinue,
                state: viewModel.viewState.isBtnContinueEnable,
                mode: .solid,
                action: {
                    Task { await viewModel.action(.validatePin) }
                }
            )
        }
    }
}

#Preview {
    FHKPreview {
        FHKValidatePinModalView(viewModel: FHKTaskStartScreenVM())
    }
}
