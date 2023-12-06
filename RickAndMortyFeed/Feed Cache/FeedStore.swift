//
//  FeedStore.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation

public typealias CacheFeed = (feed: [LocalCharacter], info: Info, timestamp: Date)

public protocol FeedStore {
    func save(feed: [LocalCharacter], timestamp: Date) throws
    func retrieve() throws -> CacheFeed?
    func deleteCacheFeed() throws
}
