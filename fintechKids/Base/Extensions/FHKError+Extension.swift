//
//  FHKError+Extension.swift
//  fintechKids
//
//  Created by Fredy Leon on 18/3/26.
//

import FHKDomain
import FHKUtils

extension FHKError {
    var messageLocalized: String {
        msnLocalizedKey.localized()
    }
}
