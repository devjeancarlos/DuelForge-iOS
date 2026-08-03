//
//  EditDeckCoordinator.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import UIKit
import SwiftUI
import Combine

public final class EditDeckCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishPublisher = PassthroughSubject<Void, Never>()
    
    private let factory: ViewModelFactory
    private let deckToUdpate: Deck
    
    public init(navigationController: UINavigationController, factory: ViewModelFactory, deck: Deck) {
        self.navigationController = navigationController
        self.factory = factory
        self.deckToUdpate = deck
    }
    
    public func start() {
        let viewModel = factory.makeEditDeckViewModel(deck: deckToUdpate)
        
        viewModel.onUpdateFinished = { [weak self] in
            //checking if EditDeckCoordinator still exists
            guard let self else { return }
            
            //Back to previous view
            self.navigationController.popViewController(animated: true)
            //Notify to the father coordinator
            self.finishPublisher.send()
        }
        
        let view = EditDeckView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "Edit Deck"
        
        navigationController.pushViewController(hostingController, animated: true)
    }
}

