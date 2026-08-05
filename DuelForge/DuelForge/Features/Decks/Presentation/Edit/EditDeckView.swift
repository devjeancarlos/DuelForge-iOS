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
            
            if !viewModel.mainDeckCards.isEmpty {
                Section(header: Text("Main Deck: \(viewModel.mainDeckCards.count) cards")) {
                    ForEach(viewModel.mainDeckCards) { card in
                        DeckCardRowView(card: card)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    let impact = UIImpactFeedbackGenerator(style: .rigid)
                                    impact.impactOccurred()
                                    
                                    viewModel.removeCard(card)
                                } label: {
                                    Label(
                                        card.copies > 1 ? "-1 Copy" : "Delete",
                                        systemImage: card.copies > 1 ? "minus.square.fill" : "trash"
                                        )
                                }
                                .tint(card.copies > 1 ? .orange: .red)
                            }
                    }
                }
            }
            
            if !viewModel.extraDeckCards.isEmpty {
                Section(header: Text("Extra Deck: \(viewModel.extraDeckCards.count) cards")) {
                    ForEach(viewModel.extraDeckCards) { card in
                        DeckCardRowView(card: card)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    let impact = UIImpactFeedbackGenerator(style: .rigid)
                                    impact.impactOccurred()
                                    
                                    viewModel.removeCard(card)
                                } label: {
                                    Label(
                                        card.copies > 1 ? "-1 Copy" : "Delete",
                                        systemImage: card.copies > 1 ? "minus.square.fill" : "trash"
                                        )
                                }
                                .tint(card.copies > 1 ? .orange: .red)
                            }
                    }
                }
            }
            
            if !viewModel.sideDeckCards.isEmpty {
                Section(header: Text("Side Deck: \(viewModel.sideDeckCards.count) cards")) {
                    ForEach(viewModel.sideDeckCards) { card in
                        DeckCardRowView(card: card)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    let impact = UIImpactFeedbackGenerator(style: .rigid)
                                    impact.impactOccurred()
                                    
                                    viewModel.removeCard(card)
                                } label: {
                                    Label(
                                        card.copies > 1 ? "-1 Copy" : "Delete",
                                        systemImage: card.copies > 1 ? "minus.square.fill" : "trash"
                                        )
                                }
                                .tint(card.copies > 1 ? .orange: .red)
                            }
                    }
                }
            }
            
            if viewModel.currentDeck.cards.isEmpty {
                Section {
                    ContentUnavailableView("No cards", systemImage: "lanyardcard", description: Text("Press '+' to add a card"))
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
        .task { //To reload deck if the user back to the previous view
            await viewModel.reloadDeck()
        }
    }
}

struct DeckCardRowView: View {
    let card: Card
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: card.imageUrl ?? "")) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 40, height: 58)
            .cornerRadius(4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(card.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(card.type)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("x\(card.copies)")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.vertical, 2)
    }
}
