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
    
    //private var diContainer: AppDIContainer
    private let factory: AppFactory
    private var cancellables = Set<AnyCancellable>()
    
    public init(navigationController: UINavigationController, factory: AppFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    public func start() {
        let viewModel = factory.makeDeckListViewModel()
        
        viewModel.onAddDeckTapped = { [weak self] in
            guard let self else { return }
            
            let createDeckCoordinator = factory.makeCreateDeckCoordinator(navigationController: self.navigationController)
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
        
        viewModel.onDeckSelected = { [weak self] selectedDeck in
            guard let self else { return }
            
            let editDeckCoordinator = factory.makeEditDeckCoordinator(navigationController: self.navigationController, deck: selectedDeck)
            self.addChild(editDeckCoordinator)
            
            editDeckCoordinator.finishPublisher.sink{ [weak self, weak editDeckCoordinator] _ in
                guard let self = self, let coordinator = editDeckCoordinator else { return }
                
                self.removeChild(coordinator)
                
                Task {
                    await viewModel.loadDecks()
                }
            }
            .store(in: &cancellables)
            
        editDeckCoordinator.start()
        }
        
        let view = DeckListView(viewModel: viewModel)
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "My Decks"
        
        navigationController.pushViewController(hostingController, animated: true)
    }
}
