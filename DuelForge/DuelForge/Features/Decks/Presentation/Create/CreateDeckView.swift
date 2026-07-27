//
//  CreateDeckView.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 27/07/26.
//

import SwiftUI

public struct CreateDeckView: View {
    @Bindable var viewModel: CreateDeckViewModel
    
    public init(viewModel: CreateDeckViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Form {
            Section(header: Text("Deck details")) {
                TextField("Name Deck (Example: YCS Lima 2026)", text: $viewModel.deckName)
                TextField("Archetype Name (Example: D/D/D)", text: $viewModel.deckArchetype)
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.saveDeck()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("Save deck")
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                })
                .disabled(!viewModel.isSaveButtonEnabled || viewModel.isSaving)
            }
        }
    }
}
