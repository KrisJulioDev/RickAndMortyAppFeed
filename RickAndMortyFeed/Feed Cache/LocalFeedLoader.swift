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
    public func save(_ feed: [CharacterItem]) throws {
        try store.deleteCacheFeed()
        try store.save(feed: feed.local(), timestamp: currentDate())
    }
}

extension LocalFeedLoader {
    public func load() throws -> (feed: [CharacterItem], info: Info?) {
        if let cache = try store.retrieve() {
            return (cache.feed.model(), cache.info)
        }
        
        return ([], nil)
    }
}

extension Array where Element == CharacterItem {
    func local() -> [LocalCharacter] {
        map {
            LocalCharacter(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, image: URL(string: $0.image ?? ""))
        }
    }
}
 
public extension Array where Element == LocalCharacter {
    func model() -> [CharacterItem] {
        map {
            CharacterItem(id: $0.id, name: $0.name, status: $0.status, species: $0.species, type: $0.type, gender: $0.gender, image: $0.image?.absoluteString)
        }
    }
}
