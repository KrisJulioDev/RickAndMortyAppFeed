//
//  CoreDataFeedImageStore.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/9/23.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {

    public func insert(_ data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedFeed.first(with: url, with: context)
                    .map { $0.data = data }
                    .map ( context.save )
            }
        }
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try performSync { context in
            Result {
                try ManagedFeed.first(with: url, in: context)
            }
        }
    }
}
