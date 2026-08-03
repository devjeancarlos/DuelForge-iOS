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
    
    private let appDIcontainer = AppDIContainer()
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        //navigationController.navigationBar.prefersLargeTitles = true
        let deckSceneDIContainer = appDIcontainer.makeDeckSceneDIContainer()
        
        let deckListCoordinator = DeckListCoordinator(
            navigationController: navigationController,
            diContainer: container
        )
        
        addChild(deckListCoordinator)
        deckListCoordinator.start()
        
        print("AppCoordinator started")
    }
}

