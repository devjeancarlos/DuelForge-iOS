//
//  CardEntity.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 28/07/26.
//

import Foundation
import SwiftData

@Model
public final class CardEntity {
    @Attribute(.unique) public var id: UUID
    public var apiId: Int
    public var name: String
    public var type: String
    public var frameType: String
    public var sector: String
    public var copies: Int
    public var imageUrl: String?
    public var banlistStatus: String
    
    public var deck: DeckEntity?
    
    public init(id: UUID, apiId: Int, name: String, type: String, frameType: String, sector: String, copies: Int, imageUrl: String? = nil, banlistStatus: String = "Unlimited") {
        self.id = id
        self.apiId = apiId
        self.name = name
        self.type = type
        self.frameType = frameType
        self.sector = sector
        self.copies = copies
        self.imageUrl = imageUrl
        self.banlistStatus = banlistStatus
    }
}

public extension CardEntity {
    func toDomain() -> Card {
        return Card(
            id: id,
            apiId: apiId,
            name: name,
            type: type,
            frameType: frameType,
            sector: DeckSector(rawValue: sector) ?? .main,
            copies: copies,
            imageUrl: imageUrl,
            banlistStatus: BanlistStatus(rawValue: banlistStatus) ?? .unlimited
        )
    }
}
