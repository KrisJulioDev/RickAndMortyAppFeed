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
    
    func test_loadEmptyFeed_retrievesEmptyData() throws {
        let (_, sut) = try makeFeedLoader()
        
        do {
            let cache = try sut.load()
            XCTAssertEqual(cache.feed, [])
            XCTAssertEqual(cache.info, nil)
        } catch {
            XCTFail("Expects to load something, got \(error)")
        }
    }
    
    func test_loadFeed_deliversItemsSavedOnDifferenceInstance() throws {
        let (_, sutToPerformSave) = try makeFeedLoader()
        let (_, sutToPerformLoad) = try makeFeedLoader()
        let saved = anyFeedCharacters()
        
        do {
            try sutToPerformSave.save(saved.local, info: anyInfo())
            let loaded = try sutToPerformLoad.load()
            XCTAssertEqual(saved.local, loaded.feed)
        } catch {
            XCTFail("Expects success returning feeds, got \(error)")
        }
    }
    
    func test_delete_hasNoErrorOnEmptyCache() throws {
        let (store, _) = try makeFeedLoader()
        
        let deletionError = deleteCacheFeed(sut: store)
        XCTAssertNil(deletionError, "Expects no error on empty cache deletion")
    }
    
    // MARK: Helpers
    
    func makeFeedLoader(
        currentDate: Date = Date(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> (store: CoreDataFeedStore, loader: LocalFeedLoader) {
        let storeURL = storeTestURL()
        let store = try CoreDataFeedStore(storeURL: storeURL)
        let loader = LocalFeedLoader(store: store, currentDate: { currentDate })
        
        trackMemoryLeak(store, file: file, line: line)
        trackMemoryLeak(loader, file: file, line: line)
        
        return (store, loader)
    }
    
    func deleteCacheFeed(sut: FeedStore) -> Error? {
        do {
            try sut.deleteCacheFeed()
            return nil
        } catch {
            return error
        }
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
