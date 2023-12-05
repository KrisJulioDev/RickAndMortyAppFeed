//
//  RickAndMortyFeedTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import XCTest
import RickAndMortyFeed


final class RickMortyAppTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performGetRequestWithURL() {
        let anyURL = anyURL()
        let exp = expectation(description: "Wait to observe")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, anyURL, "Request URL")
            XCTAssertEqual(request.httpMethod, "GET", "HTTP METHOD")
            exp.fulfill()
        }
        
        makeSUT().get(url: anyURL) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getRequest_performInitialFeedRequest() {
        let initialURL = FeedEndpoint.get().url
        let exp = expectation(description: "Wait to observe")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url?.scheme, "https", "scheme")
            XCTAssertEqual(request.url?.host(), "rickandmortyapi.com", "host")
            XCTAssertEqual(request.url?.path(), "/api/character", "path")
            XCTAssertEqual(request.httpMethod, "GET", "method")
            exp.fulfill()
        }
        
        makeSUT().get(url: initialURL) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getNextRequest_performPage3Request() {
        let initialURL = FeedEndpoint.get(nextPage).url
        let exp = expectation(description: "Wait to observe")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url?.scheme, "https", "scheme")
            XCTAssertEqual(request.url?.host(), "rickandmortyapi.com", "host")
            XCTAssertEqual(request.url?.path(), "/api/character/", "path")
            XCTAssertEqual(request.url?.query(), "page=3", "path")
            XCTAssertEqual(request.httpMethod, "GET", "method")
            exp.fulfill()
        }
        
        makeSUT().get(url: initialURL) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getPreviousRequest_performPage2Request() {
        let initialURL = FeedEndpoint.get(previousPage).url
        let exp = expectation(description: "Wait to observe")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url?.scheme, "https", "scheme")
            XCTAssertEqual(request.url?.host(), "rickandmortyapi.com", "host")
            XCTAssertEqual(request.url?.path(), "/api/character/", "path")
            XCTAssertEqual(request.url?.query(), "page=2", "path")
            XCTAssertEqual(request.httpMethod, "GET", "method")
            exp.fulfill()
        }
        
        makeSUT().get(url: initialURL) { _ in }
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPClient(session: session)
    }
    
    private var nextPage: Page {
        NextPage(count: 1, pages: 1,
            url: URL(string: "https://rickandmortyapi.com/api/character/?page=3")!
        )
    }
    
    private var previousPage: Page {
        NextPage(count: 1, pages: 1,
            url: URL(string: "https://rickandmortyapi.com/api/character/?page=2")!
        )
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

