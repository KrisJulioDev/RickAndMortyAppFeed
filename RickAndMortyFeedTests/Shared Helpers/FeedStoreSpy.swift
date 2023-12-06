//
//  FeedStoreSpy.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/6/23.
//

import RickAndMortyFeed

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessages: Equatable {
        case insert([LocalCharacter], Date)
        case retrieve
        case deleteCache
    }
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CacheFeed?, Error>?
    
    var receivedMessages: [ReceivedMessages] = []
    
    func retrieve() throws -> CacheFeed? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func save(feed: [LocalCharacter], timestamp: Date) throws {
        receivedMessages.append(.insert(feed, timestamp))
        try insertionResult?.get()
    }
    
    func insertionCompletedSuccesfully() {
        insertionResult = .success(())
    }
    
    func insertionCompleted(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func deleteCacheFeed() throws {
        receivedMessages.append(.deleteCache)
        try deletionResult?.get()
    }
    
    func deletionComplete(with error: Error) {
        deletionResult = .failure(error)
    }
    
    func deletionCompletedSuccesfully() {
        deletionResult = .success(())
    }
}
