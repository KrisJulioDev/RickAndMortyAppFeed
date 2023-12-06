//
//  FeedStore.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation

public typealias CacheFeed = (feed: [LocalCharacter], info: Info)

public protocol FeedStore {
    typealias SaveResult = Result<Void, Error>
    typealias RetrieveResult = Result<[LocalCharacter], Error>
    
    func save(feed: [LocalCharacter], timestamp: Date) throws
    func retrieve() throws -> CacheFeed?
    func deleteCacheFeed() throws
}
