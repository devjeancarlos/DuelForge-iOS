//
//  DeckListCoordinator.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import UIKit
import SwiftUI
import Combine

public final class DeckListCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishPublisher = PassthroughSubject<Void, Never>()
    
    private var diContainer: AppDIContainer
    private var cancellables = Set<AnyCancellable>()
    
    public init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    public func start() {
        let getDecksUseCase = diContainer.makeGetDeckUseCase()
        let deleteUseCase = diContainer.makeDeleteDeckUseCase()
        
        let viewModel = DeckListViewModel(
            getDecksUseCase: getDecksUseCase,
            deleteDeckuseCase: deleteUseCase
        )
        
        viewModel.onAddDeckTapped = { [weak self] in
            guard let self else { return }
            
            let createDeckCoordinator = CreateDeckCoordinator(
                navigationController: self.navigationController, diContainer: self.diContainer
                )
            
            self.addChild(createDeckCoordinator)
            
            createDeckCoordinator.finishPublisher.sink { [weak self, weak createDeckCoordinator] _ in
                guard let self, let coordinator = createDeckCoordinator else { return }
                
                self.removeChild(coordinator)
                
                Task {
                    await viewModel.loadDecks()
                }
            }
            .store(in: &self.cancellables)
            
            createDeckCoordinator.start()
        }
        
        let view = DeckListView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "My Decks"
        
        navigationController.pushViewController(hostingController, animated: true)
    }
}
