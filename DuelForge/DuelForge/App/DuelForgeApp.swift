//
//  DuelForgeApp.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 24/07/26.
//

import SwiftUI

@main
struct DuelForgeApp: App {
    private let container = AppDIContainer()
    private let navigationController = UINavigationController()
    private let appCoordinator: AppCoordinator
    
    init() {
        self.appCoordinator = AppCoordinator(
            navigationController: navigationController,
            container: container)
        
        self.appCoordinator.start()
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(navigationController: navigationController)
                .ignoresSafeArea()
        }
    }
}
