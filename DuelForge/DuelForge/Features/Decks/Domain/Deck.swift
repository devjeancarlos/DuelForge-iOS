//
//  Deck.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation

public struct Deck: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let archetype: String
    public let createdAt: Date
    public var cards: [Card]
    
    public init(id: UUID, name: String, archetype: String, createdAt: Date, cards: [Card] = []) {
        self.id = id
        self.name = name
        self.archetype = archetype
        self.createdAt = createdAt
        self.cards = cards
    }
}

public extension Deck {
    func toEntity() -> DeckEntity {
        let entity = DeckEntity(
            id: id,
            name: name,
            archetype: archetype,
            createdAt: createdAt
        )
        let cardEntities = cards.map { $0.toEntity() }
        entity.cards = cardEntities
        
        return entity
    }
}
