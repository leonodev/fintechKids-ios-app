//
//  FHKGoldenTicketEntity.swift
//  FintechHomeKids
//
//  Created by Fredy Leon on 26/9/26.
//


import Foundation
import FHKCore

public struct FHKGoldenTicketEntity: DomainModelProtocol {
    public let id: UUID = UUID()
    public let recipientName: String
    public let taskDescription: String
    public let reward: String
    public let ticketCode: String
    
    public init(recipientName: String,
         taskDescription: String,
         reward: String,
         ticketCode: String
    ) {
        self.recipientName = recipientName
        self.taskDescription = taskDescription
        self.reward = reward
        self.ticketCode = ticketCode
    }
}
