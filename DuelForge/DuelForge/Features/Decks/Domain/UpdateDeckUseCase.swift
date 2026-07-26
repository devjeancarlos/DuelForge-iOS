//
//  UpdateDeckUseCase.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation

public protocol UpdateDeckUseCaseProtocol {
    func execute(deck: Deck) async throws
}

public struct UpdateDeckUseCase: UpdateDeckUseCaseProtocol {
    let repository: DeckRepositoryProtocol
    
    public init(repository: DeckRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(deck: Deck) async throws {
        try await repository.update(deck: deck)
    }
}
