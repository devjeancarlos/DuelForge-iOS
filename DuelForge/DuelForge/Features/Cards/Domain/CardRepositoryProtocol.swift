//
//  CardRepositoryProtocol.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 30/07/26.
//

import Foundation

public protocol CardRepositoryProtocol {
    func addCard(deckID: UUID, card: Card) async throws
    func getCards(deckID: UUID) async throws -> [Card]
    func updateCardInDeck(card: Card) async throws
    func deleteCard(cardID: UUID) async throws
}
