//
//  AppCoordinator.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import UIKit
import Combine

public final class AppCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishPublisher = PassthroughSubject<Void, Never>()
    
    private let container: AppDIContainer
    public var cancellables = Set<AnyCancellable>()
    
    public init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    public func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        
        let deckListCoordinator = DeckListCoordinator(
            navigationController: navigationController,
            diContainer: container
        )
        
        addChild(deckListCoordinator)
        deckListCoordinator.start()
        
        print("AppCoordinator started")
    }
}

