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
    
    func test_loadEmptyFeed_retrievesEmptyData() {
        let sut = try? makeFeedLoader()
        
        do {
            let cache = try sut?.load()
            XCTAssertEqual(cache?.feed, [])
            XCTAssertEqual(cache?.info, nil)
        } catch {
            XCTFail("Expects to load something, got \(error)")
        }
    }
    
    func test_loadFeed_deliversItemsSavedOnDifferenceInstance() throws {
        let sutToPerformSave = try makeFeedLoader()
        let sutToPerformLoad = try makeFeedLoader()
        let saved = anyFeedCharacters()
        
        do {
            try sutToPerformSave.save(saved.local, info: anyInfo())
            let loaded = try sutToPerformLoad.load()
            XCTAssertEqual(saved.local, loaded.feed)
        } catch {
            XCTFail("Expects success returning feeds, got \(error)")
        }
    }
    
    // MARK: Helpers
    
    func makeFeedLoader(
        currentDate: Date = Date(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> LocalFeedLoader {
        let storeURL = storeTestURL()
        let feedStore = try CoreDataFeedStore(storeURL: storeURL)
        let loader = LocalFeedLoader(store: feedStore, currentDate: { currentDate })
        
        trackMemoryLeak(feedStore, file: file, line: line)
        trackMemoryLeak(loader, file: file, line: line)
        
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
