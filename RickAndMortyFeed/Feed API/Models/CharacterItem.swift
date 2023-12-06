//
//  Character.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation
 
public struct CharacterItem: Equatable, Decodable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let image: String?
    
    public init(id: Int, name: String, status: String, species: String, type: String, gender: String, image: String?) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.image = image
    }
    
    public static func == (lhs: CharacterItem, rhs: CharacterItem) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status
    }
}
