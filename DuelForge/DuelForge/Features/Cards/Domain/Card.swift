//
//  Card.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 28/07/26.
//

import Foundation

public enum DeckSector: String, Codable, CaseIterable {
    case main = "Main Deck"
    case extra = "Extra Deck"
    case side = "Side Deck"
}

public enum BanlistStatus: String, Codable {
    case forbidden = "Banned"
    case limited = "Limited"
    case semiLimited = "Semi-Limited"
    case unlimited = "Unlimited"
    
    public var maxCopiesAllowed: Int {
        switch self {
        case .forbidden:
            return 0
        case .limited:
            return 1
        case .semiLimited:
            return 2
        case .unlimited:
            return 3
        }
    }
}

public struct Card: Identifiable, Equatable {
    public let id: UUID
    public let apiID: Int
    public var name: String
    public var type: String
    public var frameType: String
    public var sector: DeckSector
    public var copies: Int
    public var imageUrl: String?
    public var banlistStatus: BanlistStatus
    
    public init(id: UUID = UUID(), apiId: Int, name: String, type: String, frameType: String, sector: DeckSector, copies: Int = 1, imageUrl: String? = nil, banlistStatus: BanlistStatus = .unlimited) {
        self.id = id
        self.apiID = apiId
        self.name = name
        self.type = type
        self.frameType = frameType
        self.sector = sector
        self.copies = copies
        self.imageUrl = imageUrl
        self.banlistStatus = banlistStatus
    }
}

public extension Card {
    func toEntity() -> CardEntity {
        return CardEntity(
            id: id,
            apiId: apiID,
            name: name,
            type: type,
            frameType: frameType,
            sector: sector.rawValue,
            copies: copies,
            imageUrl: imageUrl,
            banlistStatus: banlistStatus.rawValue)
    }
}
