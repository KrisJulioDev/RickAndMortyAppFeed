//
//  CacheUseCaseTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/6/23.
//

import XCTest
import Foundation
import RickAndMortyFeed

final class CacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotRetrieveData() {
        let (_, store) = makeSUT()
        
       XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_doesNotRequestInsertionOnDeletionError() throws {
        let (sut, store) = makeSUT()
        let deletionError = anyError()
        let info = anyInfo()
        store.deletionComplete(with: deletionError)
        
        try? sut.save([], info: info)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulCacheDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT { timestamp }
        let feed = feedCharacters()
        let info = anyInfo()
        
        store.deletionCompletedSuccesfully()
        
        try? sut.save(feed.local, info: info)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache, .insert(feed.local, info)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let error = anyError()
        
        expect(sut, toCompleteWith: error) {
            store.deletionComplete(with: error)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let error = anyError()
        
        expect(sut, toCompleteWith: error, when: {
            store.deletionCompletedSuccesfully()
            store.insertionCompleted(with: error)
        })
    }
    
    func test_save_successOnSaveCompleted() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: nil, when: {
            store.deletionCompletedSuccesfully()
            store.insertionCompletedSuccesfully()
        })
    }
    
    // MARK: Helpers
    
    func makeSUT(currentDate: @escaping () -> Date = Date.init,
                 file: StaticString = #filePath,
                 line: UInt = #line
    ) -> (loader: LocalFeedLoader, store: FeedStoreSpy) {
        let storeSpy = FeedStoreSpy()
        let feedLoader = LocalFeedLoader(store: storeSpy, currentDate: currentDate)
        
        trackMemoryLeak(storeSpy, file: file, line: line)
        trackMemoryLeak(feedLoader, file: file, line: line)

        return (feedLoader, storeSpy)
    }
 
    func expect(_ sut: LocalFeedLoader, toCompleteWith error: NSError?, when action: () -> Void) {
        let feed = feedCharacters()
        let info = anyInfo()
        
        action()
        
        var capturedError: NSError?
        do {
            try sut.save(feed.local, info: info)
        } catch {
            capturedError = error as NSError
        }
        
        XCTAssertEqual(error, capturedError)
    }
}
