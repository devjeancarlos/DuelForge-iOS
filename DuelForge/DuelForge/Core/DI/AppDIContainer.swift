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
    public lazy var apiClient: APIClientProtocol = {
        return YGOProDeckClient()
    }()
    //private let deckRepository: DeckRepositoryProtocol
    
    public init () {
        do {
            let schema = Schema([DeckEntity.self, CardEntity.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Database couldn't be initialized")
        }
    }
    
    public func makeDeckSceneDIContainer() -> DeckSceneDIContainer {
        let dependencies = DeckSceneDIContainer.Dependencies(
            apiClient: apiClient,
            modelContainer: self.modelContainer)
        
        return DeckSceneDIContainer(dependencies: dependencies)
    }
    
    /*public func makeGetDeckUseCase() -> GetDecksUseCaseProtocol {
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
    
    public func makeCardRepository() -> CardRepositoryProtocol {
        return SwiftDataCardRepository(modelContainer: self.modelContainer)
    }
    
    public func makeAddCardToDeckUseCase() -> AddCardToDeckUseCaseProtocol {
        return AddCardToDeckUseCase(repository: makeCardRepository())
    }
    
    public func makeAPIClientProtocl() -> APIClientProtocol {
        return YGOProDeckClient()
    }*/
}
