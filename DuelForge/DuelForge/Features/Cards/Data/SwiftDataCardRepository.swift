//
//  SwiftDataCardRepository.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 30/07/26.
//

import Foundation
import SwiftData

public enum CardRepositoryError: Error {
    case deckNotFound
    case cardNotFound
}

public final class SwiftDataCardRepository: CardRepositoryProtocol {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func addCard(deckID: UUID, card: Card) async throws {
        let context = modelContainer.mainContext
        
        //Searching the deck
        let descriptor = FetchDescriptor<DeckEntity>(
            predicate: #Predicate { $0.id == deckID }
        )
        
        //Validation to obtain the deck that we want to add cards
        guard let entity = try context.fetch(descriptor).first else {
            throw CardRepositoryError.deckNotFound
        }
        
        //If all is ok, add the card in the deck
        let cardEntity = card.toEntity()
        entity.cards?.append(cardEntity)
        
        //Save changes
        try context.save()
    }
    
    public func getCards(deckID: UUID) async throws -> [Card] {
        
    }
    
    //Update existing card in deck (number copies of card and sector: main, extra or side)
    public func updateCardInDeck(card: Card) async throws {
        let context = modelContainer.mainContext
        
        let descriptor = FetchDescriptor<CardEntity>(
            predicate: #Predicate { $0.id == card.id }
        )
        
        guard let entity = try context.fetch(descriptor).first .self else {
            throw CardRepositoryError.cardNotFound
        }
        
        entity.copies = card.copies
        entity.sector = card.sector.rawValue
        
        try context.save()
    }
    
    public func deleteCard(cardID: UUID) async throws {
        let context = modelContainer.mainContext
        
        let descriptor = FetchDescriptor<CardEntity>(
            predicate: #Predicate { $0.id == cardID }
        )
        
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
    }
    
    
}
