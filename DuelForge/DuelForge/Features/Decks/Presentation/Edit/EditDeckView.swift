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
            
            buildDeckSection(title: "Main Deck",
                             cards: viewModel.currentDeck.cardsBySector(for: .main),
                             totalCards: viewModel.currentDeck.totalCardsBySector(for: .main),
                             maxLimitCards: DeckSector.main.maxLimit,
                             isLegalDeck: viewModel.currentDeck.isMainDeckLegal)
            
            buildDeckSection(title: "Extra Deck",
                             cards: viewModel.currentDeck.cardsBySector(for: .extra),
                             totalCards: viewModel.currentDeck.totalCardsBySector(for: .extra),
                             maxLimitCards: DeckSector.extra.maxLimit,
                             isLegalDeck: viewModel.currentDeck.isExtraDeckLegal)
            
            buildDeckSection(title: "Side Deck",
                             cards: viewModel.currentDeck.cardsBySector(for: .side),
                             totalCards: viewModel.currentDeck.totalCardsBySector(for: .side),
                             maxLimitCards: DeckSector.side.maxLimit,
                             isLegalDeck: viewModel.currentDeck.isSideDeckLegal)
           
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
    
    @ViewBuilder
    private func buildDeckSection(title: String, cards: [Card], totalCards: Int, maxLimitCards: Int, isLegalDeck: Bool = true) -> some View {
        if !cards.isEmpty {
            Section {
                ForEach(cards) { card in
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
            } header: {
                HStack{
                    Text(title)
                    Spacer()
                    Text("\(totalCards)/\(maxLimitCards)")
                        .foregroundColor(isLegalDeck ? .secondary :.red)
                }
            }
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
