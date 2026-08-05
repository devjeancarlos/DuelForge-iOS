//
//  SearchCardViewModel.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 31/07/26.
//

import Foundation
import Observation

@Observable
@MainActor
public final class SearchCardViewModel {
    public private(set) var searchResults: [Card] = []
    public private(set) var isLoading: Bool = false
    public private(set) var errorMessage: String? = nil
    
    public var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                debounceSearch()
            }
        }
    }
    
    @ObservationIgnored public var onFinished: (() -> Void)?
    @ObservationIgnored private var searchTask: Task<Void, Never>?
    
    private let deck: Deck
    private let apiClient: APIClientProtocol
    private let addCardUseCase: AddCardToDeckUseCaseProtocol
    
    public init(deck: Deck, apiClient: APIClientProtocol, addCardUseCase: AddCardToDeckUseCaseProtocol) {
        self.deck = deck
        self.apiClient = apiClient
        self.addCardUseCase = addCardUseCase
    }
    
    private func debounceSearch() {
        searchTask?.cancel()
        let query = searchText
        
        if query.count < 3 {
            self.searchResults = []
            return
        }
        
        searchTask = Task {
            do {
                try await Task.sleep(for: .seconds(0.5))
                await performSearch(query: query)
            } catch {
                //Canceled Tassk
            }
        }
    }
    
    private func performSearch(query: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let cards = try await apiClient.searchCards(query: query)
            self.searchResults = cards
        } catch {
            self.errorMessage = "Error searching"
            self.searchResults = []
        }
        
        isLoading = false
    }
    
    public func addCardToDeck(_ card: Card) {
        Task {
            do {
                try await addCardUseCase.execute(deck: self.deck, card: card)
                self.errorMessage = nil
            } catch let error as LocalizedError {
                self.errorMessage = error.localizedDescription
            } catch {
                self.errorMessage = "Error saving card"
            }
        }
    }
    
    public func finishSearch() {
        onFinished?()
    }
    
    public func currentCopies(of card: Card) -> Int {
        deck.cards.first(where: { $0.apiID == card.apiID })?.copies ?? 0
    }
    
    public func canAddMoreCopies(of card: Card) -> Bool {
        let maxCopies = card.banlistStatus.maxCopiesAllowed
        if maxCopies == 0 {
            return false
        }
        
        return currentCopies(of: card) < min(3, maxCopies)
    }
}
