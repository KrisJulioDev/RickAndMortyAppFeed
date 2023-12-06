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
    public func save(_ feed: [LocalCharacter]) throws {
        try store.deleteCacheFeed()
        try store.save(feed: feed, timestamp: currentDate())
    }
}
