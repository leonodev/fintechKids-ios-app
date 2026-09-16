//
//  FHKCoinsRewardsParamsDto.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 16/9/26.
//

import Foundation

struct FHKCoinsRewardsParamsDto: Encodable {
    let target_member_id: UUID
    let new_coins: Int
}
