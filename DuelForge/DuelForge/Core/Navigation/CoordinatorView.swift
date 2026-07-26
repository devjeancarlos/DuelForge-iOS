//
//  CoordinatorView.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import SwiftUI
import UIKit

public struct CoordinatorView: UIViewControllerRepresentable {
    private let navigationCotroller: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationCotroller = navigationController
    }
    
    public func makeUIViewController(context: Context) -> UINavigationController {
        return navigationCotroller
    }
    
    public func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        //Empty. The coordinator controls the updates
    }
}
