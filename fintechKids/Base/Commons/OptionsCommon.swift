//
//  Options.swift
//  fintechKids
//
//  Created by fleon  on 19/5/26.
//

import FHKDesignSystem
import FHKDomain
import FHKUtils

struct OptionsCommon {
    
    static func getOptionWorkType() -> [FHKRadioOption<WorkType>] {
        [
            FHKRadioOption(value: WorkType.time,
                           label: "title_in_time".localized().capitalizingFirstLetter()),
            
            FHKRadioOption(value: WorkType.coins,
                           label: "title_in_coins".localized().capitalizingFirstLetter())
        ]
    }
    
    static func getOptionDurationType() -> [FHKRadioOption<DurationType>] {
        [
            FHKRadioOption(value: DurationType.hours,
                           label: "title_hours".localized().capitalizingFirstLetter()),
            
            FHKRadioOption(value: DurationType.days,
                           label: "title_days".localized().capitalizingFirstLetter()),
            
            FHKRadioOption(value: DurationType.weeks,
                           label: "title_weeks".localized().capitalizingFirstLetter()),
            
            FHKRadioOption(value: DurationType.months,
                           label: "title_month".localized().capitalizingFirstLetter())
        ]
    }
}
