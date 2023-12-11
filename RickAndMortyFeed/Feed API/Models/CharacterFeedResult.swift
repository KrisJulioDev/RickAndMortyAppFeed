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
  
public class Info: Decodable, Equatable {
    let count: Int
    let pages: Int
    public let next: String?
    public let prev: String?
    
    public init(count: Int, pages: Int, next: String?, prev: String?) {
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }
    
    public static func == (lhs: Info, rhs: Info) -> Bool {
            lhs.count == lhs.count
        &&  lhs.pages == lhs.pages
        &&  lhs.next == lhs.next
        &&  lhs.prev == lhs.prev
    }
}
