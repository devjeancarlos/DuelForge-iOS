//
//  DeckEntity.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation
import SwiftData

@Model
public final class DeckEntity {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var archetype: String
    public var createdAt: Date
    
    public init(id: UUID, name: String, archetype: String, createdAt: Date) {
        self.id = id
        self.name = name
        self.archetype = archetype
        self.createdAt = createdAt
    }
}

public extension DeckEntity {
    func toDomain() -> Deck {
        return Deck(
            id: self.id,
            name: self.name,
            archetype: self.archetype,
            createdAt: self.createdAt
        )
    }
}
