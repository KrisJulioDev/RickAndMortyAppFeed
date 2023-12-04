//
//  CharacterLoader.swift
//  RickMortyApp
//
//  Created by Khristoffer Julio on 12/4/23.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<Data?, Error>
    
    func get(from url: URL, completion: (@escaping (Result) -> Void))
}

public struct CharacterLoader: FeedLoader {
    let client: URLSessionHTTPClient
    
    public init(client: URLSessionHTTPClient) {
        self.client = client
    }
    
    public func get(from url: URL, completion: (@escaping (FeedLoader.Result) -> Void)) {
        completion(.success(nil))
    }
}
