//
//  FeedCacheUseCaseTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/6/23.
//

import Foundation
import XCTest
import RickAndMortyFeed

class LocalCharacter {}

typealias CacheFeed = (feed: [LocalCharacter], info: Info)

protocol FeedStore {
    typealias RetrieveResult = Result<[LocalCharacter], Error>
    
    func retrieve() throws -> CacheFeed?
}

final class FeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotRetrieveData() {
        let sut = makeSUT()
         
        XCTAssertEqual(sut.receivedMessages, [])
    }
    
    // MARK: Helpers
    
    func makeSUT() -> FeedStoreSpy {
        let storeSpy = FeedStoreSpy()
        return storeSpy
    }
    
    class FeedStoreSpy: FeedStore {
        enum ReceivedMessages {
            case insert
            case retrieve
            case delete
        }
        
        private var retrievalResult: Result<CacheFeed?, Error>?
        var receivedMessages: [ReceivedMessages] = []
        
        func retrieve() throws -> CacheFeed? {
            receivedMessages.append(.retrieve)
            return try retrievalResult?.get()
        }
        
        
    }
}
