//
//  DeckSceneDIContainer.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 1/08/26.
//

import Foundation
import SwiftData

public final class DeckSceneDIContainer {
    public struct Dependencies {
        let apiClient: APIClientProtocol
        let modelContainer: ModelContainer
    }
    
    private let dependencies: Dependencies
    
    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
