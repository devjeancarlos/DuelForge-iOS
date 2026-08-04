//
//  DuelForgeApp.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 24/07/26.
//

import SwiftUI

@main
struct DuelForgeApp: App {
    private let navigationController = UINavigationController()
    private let appCoordinator: AppCoordinator
    
    init() {
        self.appCoordinator = AppCoordinator(
            navigationController: navigationController)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(appCoordinator: appCoordinator)
                .ignoresSafeArea()
        }
    }
}
