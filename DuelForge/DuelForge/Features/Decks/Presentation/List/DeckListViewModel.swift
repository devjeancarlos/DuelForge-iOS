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
    public var onAddDeckTapped: (() -> Void)?
    
    public init(getDecksUseCase: GetDecksUseCaseProtocol) {
        self.getDecksUseCase = getDecksUseCase
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
}
