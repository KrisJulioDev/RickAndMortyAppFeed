//
//  CharacterImageMapper.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/11/23.
//

import Foundation

public final class CharacterImageMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isValid && !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
