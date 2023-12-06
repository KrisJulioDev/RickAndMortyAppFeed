//
//  FeedCacheUseCaseTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/6/23.
//

import XCTest
import Foundation
import RickAndMortyFeed

final class FeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotRetrieveData() {
        let (_, store) = makeSUT()
        
       XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_doesNotRequestInsertionOnDeletionError() throws {
        let (sut, store) = makeSUT()
        let deletionError = anyError()
        
        store.completeDeletion(with: deletionError)
        
        try? sut.save([])
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulCacheDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT { timestamp }
        let feed = feedCharacters()
        
        store.completedDeletion()
        
        try? sut.save(feed.model)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache, .insert(feed.local, timestamp)]) 
    }
     
    // MARK: Helpers
    
    func makeSUT(currentDate: @escaping () -> Date = Date.init) -> (loader: LocalFeedLoader, store: FeedStoreSpy) {
        let storeSpy = FeedStoreSpy()
        let feedLoader = LocalFeedLoader(store: storeSpy, currentDate: currentDate)
        return (feedLoader, storeSpy)
    }
    
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
            try? insertionResult?.get()
        }
        
        func completeInsertion(with error: Error) {
            insertionResult = .failure(error)
        }
        
        func deleteCacheFeed() throws {
            receivedMessages.append(.deleteCache)
            try deletionResult?.get()
        }
        
        func completeDeletion(with error: Error) {
            deletionResult = .failure(error)
        }
        
        func completedDeletion() {
            deletionResult = .success(())
        }
    }
}
