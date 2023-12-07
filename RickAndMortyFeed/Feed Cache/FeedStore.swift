//
//  FeedStore.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation

public typealias CacheFeed = (feed: [LocalCharacter], info: Info?)

public protocol FeedStore {
    func save(feed: [LocalCharacter], info: Info) throws
    func retrieve() throws -> CacheFeed?
    func deleteCacheFeed() throws
}
