//
//  EditDeckViewModel.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import Foundation
import Observation

@MainActor
@Observable
public final class EditDeckViewModel {
    public var deckName: String
    public var deckArchetype: String
    public var isSaving: Bool = false
    
    /*public var mainDeckCards: [Card] {
        currentDeck.cards.filter { $0.sector == .main }
    }
    
    public var extraDeckCards: [Card] {
        currentDeck.cards.filter { $0.sector == .extra }
    }
    
    public var sideDeckCards: [Card] {
        currentDeck.cards.filter { $0.sector == .side }
    }*/
    
    public var onUpdateFinished: (() -> Void)?
    public var onAddCardTapped: (() -> Void)?
    
    public var currentDeck: Deck
    private let updateDeckUseCase: UpdateDeckUseCaseProtocol
    private let getDeckByIdUseCase: GetDeckByIDUseCaseProtocol
    private let removeCardFromDeckUseCase: RemoveCardFromDeckUseCaseProtocol
    
    public init(deck: Deck, updateDeckUseCase: UpdateDeckUseCaseProtocol, getDeckByIDUseCase: GetDeckByIDUseCaseProtocol, removeCardFromDeckUseCase: RemoveCardFromDeckUseCaseProtocol) {
        self.currentDeck = deck
        self.deckName = deck.name
        self.deckArchetype = deck.archetype
        
        self.updateDeckUseCase = updateDeckUseCase
        self.getDeckByIdUseCase = getDeckByIDUseCase
        self.removeCardFromDeckUseCase = removeCardFromDeckUseCase
    }
    
    public var isSaveButtonEnabled: Bool {
        return !deckName.trimmingCharacters(in: .whitespaces).isEmpty && !deckArchetype.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    public func addCardTapped() {
        onAddCardTapped?()
    }
    
    public func updateDeck() async {
        guard isSaveButtonEnabled else { return }
        self.isSaving = true
        
        let updatedDeck = Deck(
            id: currentDeck.id,
            name: deckName,
            archetype: deckArchetype,
            createdAt: currentDeck.createdAt,
            cards: currentDeck.cards
        )
        
        do {
            try await updateDeckUseCase.execute(deck: updatedDeck)
            
            //Notify to coordinator
            self.onUpdateFinished?()
        } catch {
            print("Error updating deck: \(error.localizedDescription)")
            isSaving = false
        }
    }
    
    public func reloadDeck() async {
        do {
            let refreshedDeck = try await getDeckByIdUseCase.execute(id: currentDeck.id)
            
            currentDeck = refreshedDeck
        } catch {
            print("Error reloading deck: \(error.localizedDescription)")
        }
    }
    
    public func removeCard(_ card: Card) {
        Task {
            do {
                try await removeCardFromDeckUseCase.execute(card: card, deckID: currentDeck.id)
                
                await reloadDeck()
            } catch {
                print("Error removing card: \(error.localizedDescription)")
            }
        }
    }
}
