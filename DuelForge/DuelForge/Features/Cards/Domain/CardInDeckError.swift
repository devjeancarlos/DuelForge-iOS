//
//  CardInDeckError.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 30/07/26.
//

import Foundation

public enum CardInDeckError: LocalizedError {
    case exceedMaximumCopies(max: Int)
    case bannedCard
    
    public var errorDescription: String? {
        switch self {
        case .exceedMaximumCopies(let max):
            return "You can't have more than \(max) copies of this card in your deck"
        case .bannedCard:
            return "You can't use this card. Is banned"
        }
    }
}
