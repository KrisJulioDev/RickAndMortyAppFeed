//
//  CharacterLoader.swift
//  RickMortyApp
//
//  Created by Khristoffer Julio on 12/4/23.
//

import Foundation 

public protocol FeedLoader {
    typealias Result = Swift.Result<CharacterFeedResult, Error>
    
    func get(from url: URL, completion: (@escaping (Result) -> Void))
}

public class RemoteLoader: FeedLoader {
    private let client: URLSessionHTTPClient
    private var task: HTTPClientTask?
    
    public init(client: URLSessionHTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case mappingError
    }
    
    public func get(from url: URL, completion: (@escaping (FeedLoader.Result) -> Void)) {
        task = client.get(url: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                do {
                    completion(.success(try CharacterFeedMapper.map(data: data, response: response)))
                } catch {
                    completion(.failure(Error.mappingError))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
} 
