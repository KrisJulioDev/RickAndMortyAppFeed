//
//  NullStore.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/10/23.
//

import RickAndMortyFeed

class NullStore: FeedStore {
    func save(feed: [RickAndMortyFeed.LocalCharacter], info: RickAndMortyFeed.Info) throws {
         
    }
    
    func retrieve() throws -> RickAndMortyFeed.CacheFeed? {
        .none
    }
    
    func deleteCacheFeed() throws {
         
    }
}

extension NullStore: FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws {
         
    }
    
    func retrieve(dataForURL: URL) throws -> Data? {
        .none
    }
    
        
    
}
