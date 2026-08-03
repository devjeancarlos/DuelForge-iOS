//
//  SearchCardCoordinator.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 3/08/26.
//

import Foundation
import SwiftUI
import Combine

public final class SearchCardCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishPublisher = PassthroughSubject<Void, Never>()
    
    private let factory: ViewModelFactory
    private let targetDeck: Deck
    
    public init(navigationController: UINavigationController, factory: ViewModelFactory, deck: Deck) {
        self.navigationController = navigationController
        self.factory = factory
        self.targetDeck = deck
    }
    
    @MainActor
    public func start() {
        let viewModel = factory.makeSearchCardViewModel(deck: self.targetDeck)
        
        viewModel.onFinished = { [weak self] in
            guard let self else { return }
            
            self.navigationController.popViewController(animated: true)
            self.finishPublisher.send()
        }
        
        let view = SearchCardView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        
        navigationController.pushViewController(hostingController, animated: true)
    }
}
