//
//  AddCardToDeckUseCase.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 31/07/26.
//

import Foundation

public protocol AddCardToDeckUseCaseProtocol {
    func execute(deck: Deck, card: Card) async throws
}

public final class AddCardToDeckUseCase: AddCardToDeckUseCaseProtocol {
    private let repository: CardRepositoryProtocol
    
    public init(repository: CardRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(deck: Deck, card: Card) async throws {
        //Checking if the card is banned
        if card.banlistStatus == .forbidden {
            throw CardInDeckError.bannedCard
        }
        
        let existingCopies = deck.cards.filter {
            $0.id == card.id
        }
            . reduce(0) {
                $0 + $1.copies
            }
        
        let maxAllowedCopies = card.banlistStatus.maxCopiesAllowed
        
        if (existingCopies + 1) > maxAllowedCopies {
            throw CardInDeckError.exceedMaximumCopies(max: maxAllowedCopies)
        }
        
        let existingCardInSameSector = deck.cards.first {
            $0.id == card.id && $0.sector == card.sector
        }
        
        if var cardToUpdate = existingCardInSameSector {
            cardToUpdate.copies += 1
            try await repository.updateCardInDeck(card: cardToUpdate)
        } else {
            try await repository.addCard(deckID: deck.id, card: card)
        }
    }
}
