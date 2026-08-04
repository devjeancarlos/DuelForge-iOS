//
//  EditDeckView.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import SwiftUI

public struct EditDeckView: View {
    @Bindable var viewModel: EditDeckViewModel
    
    public init(viewModel: EditDeckViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Form {
            Section(header: Text("Edit Deck")) {
                TextField("Name Deck", text: $viewModel.deckName)
                TextField("Archetype Deck", text: $viewModel.deckArchetype)
            }
            
            Section(header: Text("Cards")) {
                if viewModel.currentDeck.cards.isEmpty {
                    ContentUnavailableView("No cards", systemImage: "lanyardcard", description: Text("Press '+' to add a card"))
                } else {
                    ForEach(viewModel.currentDeck.cards) { card in
                        Text(card.name)
                    }
                }
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.updateDeck()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("Update deck")
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                })
                .disabled(!viewModel.isSaveButtonEnabled || viewModel.isSaving)
            }
        }
        .navigationTitle("Edit Deck")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.addCardTapped()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
