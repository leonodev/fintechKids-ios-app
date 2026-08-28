//
//  MenuHomeItem.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 28/8/26.
//

public struct MenuHomeItem: Decodable {
    public let id: Int
    public let name: String
    public let icon: String
    public let label_localized_key: String
    public let active: Bool
    
    public init(id: Int,
                name: String,
                icon: String,
                label_localized_key: String,
                active: Bool
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.label_localized_key = label_localized_key
        self.active = active
    }
}
