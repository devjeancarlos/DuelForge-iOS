//
//  GetDeckByIDUseCase.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 4/08/26.
//

import Foundation

public protocol GetDeckByIDUseCaseProtocol {
    func execute(id: UUID) async throws -> Deck
}

public final class GetDeckByIDUseCase: GetDeckByIDUseCaseProtocol {
    private let deckRepository: DeckRepositoryProtocol
    
    public init(deckRepository: DeckRepositoryProtocol) {
        self.deckRepository = deckRepository
    }
    
    public func execute(id: UUID) async throws -> Deck {
        
        return try await deckRepository.getDeck(by: id)
    }
}
