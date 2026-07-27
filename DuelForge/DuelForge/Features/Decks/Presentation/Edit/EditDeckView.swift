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
            }
        }
    }
}
