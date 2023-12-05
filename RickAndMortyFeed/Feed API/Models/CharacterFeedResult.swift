//
//  CharacterFeedResult.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation

public class CharacterFeedResult: Decodable {
    public let info: Info
    public let results: [CharacterItem]
}
 
public class Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
