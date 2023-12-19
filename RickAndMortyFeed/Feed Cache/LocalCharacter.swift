//
//  LocalCharacter.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation
 
public struct LocalCharacter: Equatable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let location: String
    public let origin: String
    public var image: URL
    
    public init(id: Int, name: String, status: String, species: String, type: String, gender: String, image: URL, location: String, origin: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.location = location
        self.origin = origin
        self.image = image
    }
    
    public static func == (lhs: LocalCharacter, rhs: LocalCharacter) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status
    }
}
