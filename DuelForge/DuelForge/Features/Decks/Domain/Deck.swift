//
//  Deck.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation

public struct Deck: Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let archetype: String
    public let createdAt: Date
    
    public init(id: UUID, name: String, archetype: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.archetype = archetype
        self.createdAt = createdAt
    }
}
