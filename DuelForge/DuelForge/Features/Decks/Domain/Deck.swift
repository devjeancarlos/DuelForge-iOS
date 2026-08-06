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

public extension Deck {
    func cardsBySector(for sector: DeckSector) -> [Card] {
        return cards.filter{
            $0.sector == sector
        }
    }
    
    func totalCardsBySector(for sector: DeckSector) -> Int {
        return cardsBySector(for: sector).reduce(0) { total, card in
            total + card.copies
        }
    }
    
    var isMainDeckLegal: Bool {
        let total = totalCardsBySector(for: .main)
        return total >= DeckSector.main.minLimit && total <= DeckSector.main.maxLimit
    }
    
    var isExtraDeckLegal: Bool {
        let total = totalCardsBySector(for: .extra)
        return total >= DeckSector.extra.minLimit && total <= DeckSector.extra.maxLimit
    }
    
    var isSideDeckLegal: Bool {
        let total = totalCardsBySector(for: .side)
        return total >= DeckSector.side.minLimit && total <= DeckSector.side.maxLimit
    }
}
