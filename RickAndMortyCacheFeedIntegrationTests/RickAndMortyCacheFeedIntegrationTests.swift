//
//  RickAndMortyCacheFeedIntegrationTests.swift
//  RickAndMortyCacheFeedIntegrationTests
//
//  Created by Khristoffer Julio on 12/7/23.
//

import XCTest
import RickAndMortyFeed

final class RickAndMortyCacheFeedIntegrationTests: XCTestCase {
  
    override func setUp() {
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        undoSideEffectState()
    }
    
    func test_load_emptyFeedRetrievesEmptyData() {
        let sut = try? makeFeedLoader()
        
        do {
            let cache = try sut?.load()
            XCTAssertEqual(cache?.feed, [])
        } catch {
            XCTFail("Expects to load something, got \(error)")
        }
        
    }
    
    // MARK: Helpers
    
    func makeFeedLoader(currentDate: Date = Date()) throws -> LocalFeedLoader {
        let storeURL = storeTestURL()
        let feedStore = try CoreDataFeedStore(storeURL: storeURL)
        let loader = LocalFeedLoader(store: feedStore, currentDate: { currentDate })
        
        return loader
    }
    
    func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    func undoSideEffectState() {
        deleteStoreArtifacts()
    }
    
    func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: storeTestURL())
    }
    
    func storeTestURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
