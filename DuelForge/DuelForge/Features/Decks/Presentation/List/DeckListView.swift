//
//  DeckListView.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 25/07/26.
//

import SwiftUI

public struct DeckListView: View {
    @Bindable var viewModel: DeckListViewModel
    
    public init(viewModel: DeckListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            if viewModel.decks.isEmpty {
                ContentUnavailableView(
                    "Without decks",
                    systemImage: "square.stack.3d.up.slash",
                    description: Text("Create your first deck to start"))
            } else {
                VStack(spacing: 20) {
                    List {
                        ForEach(viewModel.decks) { deck in
                            Button{
                                viewModel.onDeckSelected?(deck)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(deck.name)
                                        .font(.headline)
                                    Text(deck.archetype)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete{ indexSet in
                            Task {
                                await viewModel.deleteDeck(at: indexSet)
                            }
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadDecks()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button( action: {
                    viewModel.onAddDeckTapped?()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                })
            }
        }
    }
}
