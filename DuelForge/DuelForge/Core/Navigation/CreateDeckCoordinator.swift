//
//  CreateDeckCoordinator.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import UIKit
import SwiftUI
import Combine

public final class CreateDeckCoordinator: Coordinator {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public var finishPublisher = PassthroughSubject<Void, Never>()
    
    private let diContainer: AppDIContainer
    
    public init(navigationController: UINavigationController, diContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    public func start() {
        let saveDeckUseCase = diContainer.makeSaveDeckUseCase()
        let viewModel = CreateDeckViewModel(saveDeckUseCase: saveDeckUseCase)
        
        viewModel.onSaveFinished = { [weak self] in
            //Back to previous view
            self?.navigationController.popViewController(animated: true)
            //Notify to the father coordinator
            self?.finishPublisher.send()
        }
        
        let view = CreateDeckView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "New Deck"
        
        navigationController.pushViewController(hostingController, animated: true)
    }
    
}
