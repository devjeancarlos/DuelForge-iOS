//
//  DeckSceneDIContainer.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 1/08/26.
//

import Foundation
import UIKit
import SwiftData

public final class DeckSceneDIContainer {
    public struct Dependencies {
        let apiClient: APIClientProtocol
        let modelContainer: ModelContainer
    }
    
    private let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    private func makeDeckRepository() -> DeckRepositoryProtocol {
        return SwiftDataDeckRepository(container: dependencies.modelContainer)
    }
    
    private func makeCardRepository() -> CardRepositoryProtocol {
        return SwiftDataCardRepository(modelContainer: dependencies.modelContainer)
    }
    
    private func makeGetDecksUseCase() -> GetDecksUseCaseProtocol {
        return GetDecksUseCase(repository: makeDeckRepository())
    }
    
    private func makeSaveDeckUseCase() -> SaveDeckUseCaseProtocol {
        return SaveDeckUseCase(repository: makeDeckRepository())
    }
    
    private func makeDeleteDeckUseCase() -> DeleteDeckUseCaseProtocol {
        return DeleteDeckUseCase(repository: makeDeckRepository())
    }
    
    private func makeUpdateDeckUseCase() -> UpdateDeckUseCaseProtocol {
        return UpdateDeckUseCase(repository: makeDeckRepository())
    }
    
    private func makeAddCardToDeckUseCase() -> AddCardToDeckUseCaseProtocol {
        return AddCardToDeckUseCase(repository: makeCardRepository())
    }
}

extension DeckSceneDIContainer: AppFactory {
    public func makeDeckListViewModel() -> DeckListViewModel {
        return DeckListViewModel(getDecksUseCase: makeGetDecksUseCase(), deleteDeckuseCase: makeDeleteDeckUseCase())
    }
    
    public func makeCreateDeckViewModel() -> CreateDeckViewModel {
        return CreateDeckViewModel(saveDeckUseCase: makeSaveDeckUseCase())
    }
    
    public func makeEditDeckViewModel(deck: Deck) -> EditDeckViewModel {
        return EditDeckViewModel(deck: deck, updateDeckUseCase: makeUpdateDeckUseCase())
    }
    
    @MainActor
    public func makeSearchCardViewModel(deck: Deck) -> SearchCardViewModel {
        return SearchCardViewModel(deck: deck, apiClient: dependencies.apiClient, addCardUseCase: makeAddCardToDeckUseCase())
    }
    
    public func makeCreateDeckCoordinator(navigationController: UINavigationController) -> Coordinator {
        return CreateDeckCoordinator(navigationController: navigationController, factory: self)
    }
    
    public func makeEditDeckCoordinator(navigationController: UINavigationController, deck: Deck) -> Coordinator {
        return EditDeckCoordinator(navigationController: navigationController, factory: self, deck: deck)
    }
    
    public func makeSearchCardCoordinator(navigationController: UINavigationController, deck: Deck) -> Coordinator {
        return SearchCardCoordinator(navigationController: navigationController, factory: self, deck: deck)
    }
}
