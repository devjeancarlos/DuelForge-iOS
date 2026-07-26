//
//  DeleteDeckUseCase.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation

public protocol DeleteDeckUseCaseProtocol {
    func execute(id: UUID) async throws
}

public struct DeleteDeckUseCase: DeleteDeckUseCaseProtocol {
    private let repository: DeckRepositoryProtocol
    
    public init(repository: DeckRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(id: UUID) async throws {
        try await repository.delete(id: id)
    }
}
