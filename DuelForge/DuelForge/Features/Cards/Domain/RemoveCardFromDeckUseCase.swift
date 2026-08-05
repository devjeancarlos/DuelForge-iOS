//
//  RemoveCardFromDeckUseCase.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 5/08/26.
//

import Foundation

public protocol RemoveCardFromDeckUseCaseProtocol {
    func execute(card: Card, deckID: UUID) async throws
}

public final class RemoveCardFromDeckUseCase: RemoveCardFromDeckUseCaseProtocol {
    private let cardRepository: CardRepositoryProtocol
    
    public init(cardRepository: CardRepositoryProtocol) {
        self.cardRepository = cardRepository
    }
    
    public func execute(card: Card, deckID: UUID) async throws {
        try await cardRepository.removeCardFromDeck(deckID: deckID, card: card)
    }
}
