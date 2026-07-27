//
//  CreateDeckViewModel.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import Foundation
import Observation

@Observable
public final class CreateDeckViewModel {
    public var deckName: String = ""
    public var deckArchetype: String = ""
    public var isSaving: Bool = false
    
    public var onSaveFinished: (() -> Void)?
    private let saveDeckUseCase: SaveDeckUseCaseProtocol
    
    public init(saveDeckUseCase: SaveDeckUseCaseProtocol) {
        self.saveDeckUseCase = saveDeckUseCase
    }
    
    public var isSaveButtonEnabled: Bool {
        return !deckName.trimmingCharacters(in: .whitespaces).isEmpty && !deckArchetype.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @MainActor
    public func saveDeck() async {
        guard isSaveButtonEnabled else { return }
        self.isSaving = true
        
        let newDeck = Deck(id: UUID(), name: deckName, archetype: deckArchetype, createdAt: Date())
        
        do {
            try await saveDeckUseCase.execute(deck: newDeck)
            self.onSaveFinished?()
        } catch {
            print("Error to save deck: \(error.localizedDescription)")
        }
        self.isSaving = false
    }
}
