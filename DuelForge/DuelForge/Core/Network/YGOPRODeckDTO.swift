//
//  YGOPRODeckDTO.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 28/07/26.
//

import Foundation

public struct YGOPRODeckResponseDTO: Codable {
    public let data: [CardDTO]
}

public struct CardDTO: Codable {
    public let id: Int
    public let name: String
    public let type: String
    public let frameType: String
    public let desc: String
    public let card_images: [CardImageDTO]?
    public let banlist_info: BanlistInfoDTO?
}

public struct CardImageDTO: Codable {
    public var id: Int
    public var image_url: String
    public var image_url_small: String
    public var image_url_cropped: String
}

public struct BanlistInfoDTO: Codable {
    public let ban_tcg: String?
}

public extension CardDTO {
    func toDomain() -> Card {
        let smallImageUrl = card_images?.first?.image_url_small ?? ""
        
        var sector: DeckSector
        let extraDeckFrames = [
            "fusion", "synchro", "xyz", "link",
            "fusion_pendulum", "synchro_pendulum", "xyz_pendulum"
        ]
        
        if extraDeckFrames.contains(self.frameType.lowercased()) {
            sector = .extra
        } else {
            sector = .main
        }
        
        let status = banlist_info?.ban_tcg ?? "Unlimited"
        let finalBanlistStatus = BanlistStatus(rawValue: status) ?? .unlimited
        
        return Card(
            id: UUID(),
            apiId: self.id,
            name: self.name,
            type: self.type,
            frameType: self.frameType,
            sector: sector,
            copies: 1,
            imageUrl: smallImageUrl,
            banlistStatus: finalBanlistStatus
        )
    }
}
