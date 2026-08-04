//
//  CoordinatorView.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import SwiftUI
import UIKit

public struct CoordinatorView: UIViewControllerRepresentable {
    private let appCoordinator: AppCoordinator
    
    public init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        appCoordinator.start()
        return appCoordinator.navigationController
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        //Empty. The coordinator controls the updates
    }
}
