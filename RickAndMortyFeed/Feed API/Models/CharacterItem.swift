//
//  Character.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation
 
public struct CharacterItem: Hashable, Decodable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let image: URL
    public let location: Location
    public let origin: Origin
    
    public init(id: Int, 
                name: String,
                status: String,
                species: String,
                type: String,
                gender: String,
                image: URL, 
                location: String,
                origin: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.image = image
        self.location = Location(name: location)
        self.origin = Origin(name: origin)
    }
    
    public static func == (lhs: CharacterItem, rhs: CharacterItem) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status
    }
}

public struct Location: Hashable, Decodable {
    public let name: String
}

public struct Origin: Hashable, Decodable {
    public let name: String
}
