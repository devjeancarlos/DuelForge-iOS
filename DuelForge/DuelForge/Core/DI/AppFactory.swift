//
//  AppFactory.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 1/08/26.
//

import Foundation
import UIKit

//Exclusive menu of ViewModels
public protocol ViewModelFactory {
    func makeDeckListViewModel() -> DeckListViewModel
    func makeCreateDeckViewModel() -> CreateDeckViewModel
    func makeEditDeckViewModel(deck: Deck) -> EditDeckViewModel
    @MainActor func makeSearchCardViewModel(deck: Deck) -> SearchCardViewModel
}

//Exclusive menu of child Coordinators (coordinators that we navigate, not home (not DeckListCoordinator))
public protocol CoordinatorsFactory {
    func makeCreateDeckCoordinator(navigationController: UINavigationController) -> Coordinator
    func makeEditDeckCoordinator(navigationController: UINavigationController, deck: Deck) -> Coordinator
    func makeSearchCardCoordinator(navigationController: UINavigationController, deck: Deck) -> Coordinator
}

//Complete menu
public typealias AppFactory = ViewModelFactory & CoordinatorsFactory
