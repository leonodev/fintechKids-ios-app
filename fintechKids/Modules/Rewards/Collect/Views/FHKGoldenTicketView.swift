//
//  FHKGoldenTicketView.swift
//  fintechKids
//
//  Created by Fredy Leon on 26/3/26.
//

import SwiftUI
import FHKDesignSystem // Asumimos que aquí están tus fuentes y colores base

// MARK: - Preview
#Preview {
    PreviewContainer {
        GoldenTicketView(
            recipientName: "MARIA GARCIA",
            taskDescription: "HACER LOS DEBERES DEL SABADO",
            reward: "1050 KIDCOINS",
            validUntil: "ENERO 2027",
            ticketCode: "FHK-GTR-789012"
        )
    }
}
