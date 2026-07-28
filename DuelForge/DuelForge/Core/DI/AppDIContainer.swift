//
//  AppDIContainer.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import Foundation
import SwiftData

@MainActor
public final class AppDIContainer {
    public let modelContainer: ModelContainer
    private let deckRepository: DeckRepositoryProtocol
    
    public init () {
        do {
            let schema = Schema([DeckEntity.self, CardEntity.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            self.deckRepository = SwiftDataDeckRepository(container: modelContainer)
        } catch {
            fatalError("ModelContainer could not be initialized")
        }
    }
    
    public func makeGetDeckUseCase() -> GetDecksUseCaseProtocol {
        return GetDecksUseCase(repository: deckRepository)
    }
    
    public func makeDeleteDeckUseCase() -> DeleteDeckUseCaseProtocol {
        return DeleteDeckUseCase(repository: deckRepository)
    }
    
    public func makeSaveDeckUseCase() -> SaveDeckUseCaseProtocol {
        return SaveDeckUseCase(repository: deckRepository)
    }
    
    public func makeUpdateDeckUseCase() -> UpdateDeckUseCaseProtocol {
        return UpdateDeckUseCase(repository: deckRepository)
    }
}
