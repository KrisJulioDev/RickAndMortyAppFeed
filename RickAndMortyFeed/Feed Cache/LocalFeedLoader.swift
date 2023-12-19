//
//  LocalFeedLoader.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation
 
public class LocalFeedLoader {
    let store: FeedStore
    let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
}

extension LocalFeedLoader {
    public func save(_ feed: [LocalCharacter], info: Info) throws {
        try store.deleteCacheFeed()
        try store.save(feed: feed, info: info)
    }
}

extension LocalFeedLoader {
    public func load() throws -> CacheFeed {
        if let cache = try store.retrieve() {
            return cache
        }
        
        return CacheFeed(feed: [], info: nil)
    }
}

extension Array where Element == CharacterItem {
    func local() -> [LocalCharacter] {
        map {
            LocalCharacter(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, image: $0.image, location: $0.location.name, origin: $0.origin.name)
        }
    }
}
 
public extension Array where Element == LocalCharacter {
    func model() -> [CharacterItem] {
        map {
            CharacterItem(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, image: $0.image, location: $0.location, origin: $0.origin)
        }
    }
}
