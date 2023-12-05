//
//  CharacterFeedMapper.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation

public struct CharacterFeedMapper {
    public enum MappingError: Error {
        case invalidData
        case invalidResponse
    }
    
    public static func map(data: Data, response: HTTPURLResponse) throws -> CharacterFeedResult {
        do {
            guard response.isValid else {
                throw MappingError.invalidResponse
            }
            
            return try JSONDecoder().decode(CharacterFeedResult.self, from: data)
        } catch {
            throw MappingError.invalidData
        }
    }
}

extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    
    public var isValid: Bool {
        statusCode == Self.OK_200
    }
}
