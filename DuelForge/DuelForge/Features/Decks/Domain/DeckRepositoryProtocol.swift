//
//  DeckRepositoryProtocol.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation

public protocol DeckRepositoryProtocol {
    func getDecks() async throws -> [Deck]
    func delete(id: UUID) async throws
    func save(deck: Deck) async throws
    func update(deck: Deck) async throws
}
