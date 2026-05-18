//
//  RewardEntity+Extension.swift.swift
//  fintechKids
//
//  Created by Fredy Leon on 4/4/26.
//

import FHKDomain

extension RewardEntity {
    /// Devuelve el costo de la recompensa normalizado en horas.
    var requiredHours: Int {
        timeRequiered.asHours
    }
}
