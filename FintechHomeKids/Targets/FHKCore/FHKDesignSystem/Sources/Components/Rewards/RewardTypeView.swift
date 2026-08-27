//
//  RewardTypeView.swift
//  FHKDesignSystem
//
//  Created by Fredy Leon on 13/3/26.
//

import SwiftUI

public struct FHKRewardTypeView: View {
    let value: String
    let type: RewardType
    
    public init(value: String, type: RewardType) {
        self.value = value
        self.type = type
    }
    
    public enum RewardType {
        case time
        case coins
        
        var nameIcon: String {
            switch self {
            case .coins:
                "crown.fill"
                
            case .time:
                "watch.analog"
    
            }
        }
        
        var colorIcon: Color {
            switch self {
            case .coins:
                FHKColor.yellow
                
            case .time:
                FHKColor.fuchsiaPink
            }
        }
        
        var heightIcon: CGFloat {
            switch self {
            case .coins:
                FHKSize.size20
                
            case .time:
                FHKSize.size28
            }
        }
    }
    
    public var body: some View {
        HStack {
            
            Image(systemName: type.nameIcon)
                .resizable()
                .frame(width: FHKSize.size20, height: type.heightIcon)
                .foregroundColor(type.colorIcon)
            
            Text(value)
                .font(.PangramSans.bold(FHKSize.size16))
                .foregroundColor(FHKColor.lunarSand.opacity(0.6))
        }
    }
}

