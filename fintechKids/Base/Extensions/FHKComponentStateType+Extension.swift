//
//  FHKComponentStateType+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 24/4/26.
//

import FHKDesignSystem
import FHKUtils

extension FHKComponentStateType {
    static var defaultDataError: FHKComponentStateType {
        .error("title_data_unavailable".localized().capitalizingFirstLetter())
    }
}
