//
//  LoadCacheUseCaseTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/6/23.
//
 
import XCTest
import RickAndMortyFeed

class LoadCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotLoadAnyData() {
        let (_, store) = makeSUT()
         
        XCTAssertEqual(store.receivedMessages, [])
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
}
