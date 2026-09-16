//
//  FHKTimeRewardsParamsDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/9/26.
//

import Foundation

struct FHKTimeRewardsParamsDto: Encodable {
    let target_member_id: UUID
    let new_time_string: String
}
