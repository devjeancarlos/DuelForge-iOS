//
//  APIClient.swift
//  DuelForge
//
//  Created by Jean Carlos Ramos Cruz on 31/07/26.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case invaludURL
    case serverError(statusCode: Int)
    case decodingError
    case noData
    
    public var errorDescription: String? {
        switch self {
        case .invaludURL:
            return "Invalid URL"
        case .serverError(let code):
            return "Server Error: \(code)"
        case .decodingError:
            return "Decoding Error"
        case .noData:
            return "No Data"
        }
    }
}

public protocol APIClientProtocol {
    func searchCards(query: String) async throws -> [Card]
}

public final class YGOProDeckClient: APIClientProtocol {
    private let baseURL = "https://db.ygoprodeck.com/api/v7/cardinfo.php"
    private let urlsession: URLSession
    
    public init(urlsession: URLSession = .shared) {
        self.urlsession = urlsession
    }
    
    public func searchCards(query: String) async throws -> [Card] {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invaludURL
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "fname", value: query)]
        
        guard let finalURL = urlComponents.url else {
            throw NetworkError.invaludURL
        }
        
        //Api call
        let (data, response) = try await urlsession.data(from: finalURL)
        
        //Checking server answer
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(statusCode: 0)
        }
        
        //No cards
        if httpResponse.statusCode == 400 {
            return []
        }
        
        //Manage server errors
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        //Decoding JSON to DTO
        do {
            let decoder = JSONDecoder()
            let responseDTO = try decoder.decode(YGOPRODeckResponseDTO.self, from: data)
            
            let cards = responseDTO.data.map {
                $0.toDomain()
            }
            
            return cards
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
