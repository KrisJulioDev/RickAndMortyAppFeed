//
//  CharacterLoader.swift
//  RickMortyApp
//
//  Created by Khristoffer Julio on 12/4/23.
//

import Foundation

public class Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

public class CharacterFeedResult: Decodable {
    public let info: Info
    public let results: [CharacterItem]
}

public protocol FeedLoader {
    typealias Result = Swift.Result<CharacterFeedResult, Error>
    
    func get(from url: URL, completion: (@escaping (Result) -> Void))
}

public struct CharacterLoader: FeedLoader {
    let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidResponse
    }
    
    public func get(from url: URL, completion: (@escaping (FeedLoader.Result) -> Void)) {
         
    }
} 
