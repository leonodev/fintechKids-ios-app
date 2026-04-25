//
//  ComponentStateType+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/4/26.
//

import FHKDesignSystem
import FHKUtils

extension ComponentStateType {
    static var defaultDataError: ComponentStateType {
        .error("title_data_unavailable".localized().capitalizingFirstLetter())
    }
}
