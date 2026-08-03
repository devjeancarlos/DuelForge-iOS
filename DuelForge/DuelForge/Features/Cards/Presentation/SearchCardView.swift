//
//  SearchCardView.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 3/08/26.
//

import SwiftUI

public struct SearchCardView: View {
    @Bindable var viewModel: SearchCardViewModel
    
    public init(viewModel: SearchCardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            if viewModel.isLoading {
                HStack{
                    Spacer()
                    ProgressView("Searching in database")
                        .padding()
                    Spacer()
                }
            }
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            ForEach(viewModel.searchResults) { card in
                CardSearchResultRow(card: card) {
                    viewModel.addCardToDeck(card)
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Black Magician")
        .navigationTitle(Text("Search card"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.finishSearch()
                }
                .fontWeight(.bold)
            }
        }
    }
}

struct CardSearchResultRow: View {
    let card: Card
    let onAddTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: card.imageUrl ?? "")) { image in
                image.resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 50, height: 73)
            .cornerRadius(4)
            
            //Details card
            VStack(alignment: .leading, spacing: 4) {
                Text(card.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(card.type)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: onAddTapped) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .frame(width: 44, height: 44)
        }
        .padding(.vertical, 4)
    }
}
