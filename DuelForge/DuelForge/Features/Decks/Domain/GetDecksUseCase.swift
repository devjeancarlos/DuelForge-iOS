//
//  GetDeckUseCase.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation

public protocol GetDecksUseCaseProtocol {
    func execute() async throws -> [Deck]
}

public struct GetDecksUseCase: GetDecksUseCaseProtocol {
    private let repository: DeckRepositoryProtocol
    
    public init(repository: DeckRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Deck] {
        return try await repository.getDecks()
    }
}
