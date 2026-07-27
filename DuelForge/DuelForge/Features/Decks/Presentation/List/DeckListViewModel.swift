//
//  DeckListViewModel.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import Foundation
import Observation

@Observable
public class DeckListViewModel {
    public var decks: [Deck] = []
    private let getDecksUseCase: GetDecksUseCaseProtocol
    private let deleteDeckUseCase: DeleteDeckUseCaseProtocol
    
    public var onAddDeckTapped: (() -> Void)?
    public var onDeckSelected: ((Deck) -> Void)?
    
    public init(getDecksUseCase: GetDecksUseCaseProtocol, deleteDeckuseCase: DeleteDeckUseCaseProtocol) {
        self.getDecksUseCase = getDecksUseCase
        self.deleteDeckUseCase = deleteDeckuseCase
    }
    
    @MainActor
    public func loadDecks() async {
        do {
            self.decks = try await self.getDecksUseCase.execute()
            print("Decks loaded")
        } catch {
            print("Error loading decks: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    public func deleteDeck(at offsets: IndexSet) async {
        for index in offsets { //index tell us what row was swipped
            let deckToDelete = self.decks[index]
            
            do {
                try await deleteDeckUseCase.execute(id: deckToDelete.id)
                self.decks.remove(at: index)
            } catch {
                print("Error deleting deck: \(error.localizedDescription)")
            }
        }
    }
}
