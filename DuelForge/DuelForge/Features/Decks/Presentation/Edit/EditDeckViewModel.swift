//
//  EditDeckViewModel.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import Foundation
import Observation

@Observable
public final class EditDeckViewModel {
    public var deckName: String
    public var deckArchetype: String
    public var isSaving: Bool = false
    
    public var onUpdateFinished: (() -> Void)?
    
    private let originalDeck: Deck
    private let updateDeckUseCase: UpdateDeckUseCaseProtocol
    
    public init(deck: Deck, updateDeckUseCase: UpdateDeckUseCaseProtocol) {
        self.originalDeck = deck
        self.deckName = deck.name
        self.deckArchetype = deck.archetype
        
        self.updateDeckUseCase = updateDeckUseCase
    }
    
    public var isSaveButtonEnabled: Bool {
        return !deckName.trimmingCharacters(in: .whitespaces).isEmpty && !deckArchetype.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @MainActor
    public func updateDeck() async {
        guard isSaveButtonEnabled else { return }
        self.isSaving = true
        
        let updatedDeck = Deck(
            id: originalDeck.id,
            name: deckName,
            archetype: deckArchetype,
            createdAt: originalDeck.createdAt
        )
        
        do {
            try await updateDeckUseCase.execute(deck: updatedDeck)
            
            //Notify to coordinator
            self.onUpdateFinished?()
        } catch {
            print("Error updating deck: \(error.localizedDescription)")
        }
    }
}
