//
//  RickAndMortyFeedEndToEndTests.swift
//  RickAndMortyFeedEndToEndTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import XCTest
import RickAndMortyFeed

final class RickAndMortyFeedEndToEndTests: XCTestCase {
    
    func test_getFirstPageRequest_retrievesFirstPageData() {
        let loader = makeSUT()
        let exp = expectation(description: "Wait to load")
        
        loader.get(from: FeedEndpoint.get().url, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let result):
                XCTAssertEqual(result.results.count, 20)
                XCTAssertEqual(result.results.map { $0.id }, Array(1...20))
            case .failure(let error):
                XCTFail("Expecting success, got \(error)")
            }
            
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 5.0)
    }
    
    func test_getSecondPageRequest_retrievesSecondPageData() {
        let loader = makeSUT()
        let exp = expectation(description: "Wait to load")
        let page = NextPage(url: URL(string: "https://rickandmortyapi.com/api/character/?page=2")!)
        
        loader.get(from: FeedEndpoint.get(page).url, completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let result):
                XCTAssertEqual(result.results.count, 20)
                XCTAssertEqual(result.results.map { $0.id }, Array(21...40))
            case .failure(let error):
                XCTFail("Expecting success, got \(error)")
            }
            
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 5.0)
    }
    
    // MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CharacterLoader {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = CharacterLoader(client: client)
         
        trackMemoryLeak(client, file: file, line: line)
        trackMemoryLeak(loader, file: file, line: line)
        
        return loader
    }
}

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be nil, potential memory leaks", file: file, line: line)
        }
    }
}
