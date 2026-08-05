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
                CardSearchResultRow(card: card, currentCopies: viewModel.currentCopies(of: card), canAddMore: viewModel.canAddMoreCopies(of: card)) {
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
    let currentCopies: Int
    let canAddMore: Bool
    let onAddTapped: () -> Void
    
    @State private var showSuccess = false
    
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
            VStack(alignment: .leading, spacing: 6) {
                Text(card.name)
                    .font(.headline)
                    .lineLimit(2)
                HStack {
                    Text(card.type)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if card.banlistStatus != .unlimited {
                        Text(card.banlistStatus.rawValue.uppercased())
                            .font(.caption2).bold()
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(card.banlistStatus.maxCopiesAllowed == 0 ? Color.red : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                
                if card.banlistStatus.maxCopiesAllowed == 0 {
                    Text("FORBIDDEN - 0 allowed")
                        .font(.caption2).bold().foregroundColor(.red)
                } else if currentCopies > 0 {
                    Text("\(currentCopies)/\(min(3, card.banlistStatus.maxCopiesAllowed)) in the deck")
                        .font(.caption2).foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            Button(action: {
                guard canAddMore else { return } //To validate
                
                let impactmed = UIImpactFeedbackGenerator(style: .medium)
                impactmed.impactOccurred()
                
                onAddTapped()
                
                withAnimation(.spring(response:0.3, dampingFraction: 0.6)) {
                    showSuccess = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation {
                        showSuccess = false
                    }
                }
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(showSuccess ? .green : (canAddMore ? .blue : .gray.opacity(0.5)))
            })
            .disabled(!canAddMore)
            .frame(width: 44, height: 44)
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}
