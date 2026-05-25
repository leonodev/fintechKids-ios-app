//
//  View+Extension.swift
//  fintechKids
//
//  Created by fleon  on 18/5/26.
//

import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            EmptyView()
        } else {
            self
        }
    }
}
