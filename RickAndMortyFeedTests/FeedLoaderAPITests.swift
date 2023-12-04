//
//  RickAndMortyFeedTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import XCTest
import RickAndMortyFeed

public class Page  {
    let count: Int
    let pages: Int
    let url: URL
    
    init(count: Int, pages: Int, url: URL) {
        self.count = count
        self.pages = pages
        self.url = url
    }
}

public class NextPage: Page {
    
}

public enum FeedEndpoint {
    case get(page: Page?)
    
    var url: URL {
        switch self {
        case let .get(page):
            let initialURL = URL(string: "https://rickandmortyapi.com/api/character")!
            return page?.url ?? initialURL
        }
    }
}

final class RickMortyAppTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_loadRequest_firstRequestHasInitialURL() {
        let anyURL = URL(string: "any-url")!
        let exp = expectation(description: "Wait to observe")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, anyURL, "Request URL")
            XCTAssertEqual(request.httpMethod, "GET", "HTTP METHOD")
            exp.fulfill()
        }
        
        makeSUT().get(url: anyURL) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPClient(session: session)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        func get(url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            
            let session = URLSessionHTTPClient(session: .shared)
            
            let task = session.get(url: url, completion: { _ in
                
            })
            
            return task
        }
    }
}

