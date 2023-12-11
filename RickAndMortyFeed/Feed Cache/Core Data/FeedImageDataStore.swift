//
//  FeedImageDataStore.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/9/23.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL: URL) throws -> Data?
}

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
