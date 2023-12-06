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

    func test_load_completedWithErrorDoesNotRetrieve() {
        let (sut, store) = makeSUT()
        let anyError = anyError()

        store.retrieveCompleted(with: anyError)

        var capturedError: NSError?
        do {
            _ = try sut.load()
        } catch {
            capturedError = error as NSError
        }
        
        XCTAssertEqual(anyError, capturedError)
    }
    
    func test_load_retrieveEmptyFeedOnEmptyData() {
        let (sut, store) = makeSUT()
        let emptyFeed = CacheFeed(feed: [], info: nil, timestamp: Date())
        store.retrieveSuccesfully(with: emptyFeed)
        
        var capturedFeed: CacheFeed?
        do {
            capturedFeed = try sut.load()
        } catch {
            XCTFail("Expects success, got \(error)")
        }
        
        XCTAssertNotNil(capturedFeed)
        XCTAssertTrue(capturedFeed!.feed.isEmpty)
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
