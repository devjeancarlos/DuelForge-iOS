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
    case maxCopiesReached
    
    public var errorDescription: String? {
        switch self {
        case .deckNotFound:
            return "Deck not found"
        case .cardNotFound:
            return "Card not found"
        case .maxCopiesReached:
            return "Max copies reached"
        }
    }
}

public final class SwiftDataCardRepository: CardRepositoryProtocol {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    public func addCard(deckID: UUID, card: Card) async throws {
        let context = modelContainer.mainContext
        let targetDeckId = deckID
        let targetApiIDCard = card.apiID
        
        //Searching the deck
        let descriptor = FetchDescriptor<DeckEntity>(
            predicate: #Predicate { $0.id == targetDeckId }
        )
        
        //Validation to obtain the deck that we want to add cards
        guard let deckEntity = try context.fetch(descriptor).first else {
            throw CardRepositoryError.deckNotFound
        }
        
        let limitCards = card.banlistStatus.maxCopiesAllowed
        guard limitCards > 0 else {
            throw CardInDeckError.bannedCard
        }
        
        if let existingCardEntity = deckEntity.cards?.first(where: { $0.apiId == targetApiIDCard}) {
            if existingCardEntity.copies >= limitCards || existingCardEntity.copies >= 3 {
                throw CardRepositoryError.maxCopiesReached
            }
            existingCardEntity.copies += 1
        } else {
            //If all is ok, add the card in the deck
            let cardEntity = card.toEntity()
            deckEntity.cards?.append(cardEntity)
        }
        
        //Save changes
        try context.save()
    }
    
    public func getCards(deckID: UUID) async throws -> [Card] {
        let context = modelContainer.mainContext
        let targetDeckId = deckID
        /*
         let descriptor = FetchDescriptor<CardEntity>(
         predicate: #Predicate { $0.deck?.id == targetDeckId },
         sortBy: [SortDescriptor(\.name, order: .forward)]
         )
         
         let cards = try context.fetch(descriptor)
         
         return cards.map{ $0.toDomain() }*/
        
        //to avoid the potential warning for use $0.deck?.id Implement in this form:
        let descriptor = FetchDescriptor<DeckEntity>(
            predicate: #Predicate { $0.id == targetDeckId }
        )
        
        guard let deck = try context.fetch(descriptor).first, let cards = deck.cards else {
            return []
        }
        
        return cards.map { $0.toDomain() }
            .sorted {
                $0.name < $1.name
            }
    }
    
    //Update existing card in deck (number copies of card and sector: main, extra or side)
    public func updateCardInDeck(card: Card) async throws {
        let context = modelContainer.mainContext
        let targetID = card.id
        
        let descriptor = FetchDescriptor<CardEntity>(
            predicate: #Predicate { $0.id == targetID }
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
