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
    
    func test_getRequest_performInitialFeedRequest() {
        let initialURL = FeedEndpoint.get(page: nil).url
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

