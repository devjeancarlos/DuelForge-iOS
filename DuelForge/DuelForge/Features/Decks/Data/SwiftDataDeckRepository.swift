//
//  SwiftDataDeckRepository.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation
import SwiftData

@MainActor
public final class SwiftDataDeckRepository: DeckRepositoryProtocol {
    private let context: ModelContext
    
    public init(container: ModelContainer) {
        self.context = ModelContext(container)
    }
    
    public func getDecks() async throws -> [Deck] {
        let descriptor = FetchDescriptor<DeckEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let entities = try context.fetch(descriptor)
        
        return entities.map { $0.toDomain() }
    }
    
    public func delete(id: UUID) async throws {
        let targetID = id
        let descriptor = FetchDescriptor<DeckEntity>(
            predicate: #Predicate { $0.id == targetID}
        )
        
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
    }
    
    public func save(deck: Deck) async throws {
        let entity = DeckEntity(id: deck.id, name: deck.name, archetype: deck.archetype, createdAt: deck.createdAt)
        context.insert(entity)
        
        try context.save()
    }
    
    public func update(deck: Deck) async throws {
        let targetId = deck.id
        
        let descriptor = FetchDescriptor<DeckEntity>(
            predicate: #Predicate { $0.id == targetId }
        )
        
        if let entity = try context.fetch(descriptor).first {
            entity.name = deck.name
            entity.archetype = deck.archetype
            
            try context.save()
        } else {
            print("Error: Could not update the deck, it does not exist in the database.")
        }
    }
}
