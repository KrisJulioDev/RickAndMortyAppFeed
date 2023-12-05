//
//  FeedItemMapperTests.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import XCTest
import RickAndMortyFeed

final class FeedItemMapperTests: XCTestCase {
 
    func test_map_deliversErrorOnNonHTTP200Response() throws {
        let statusCodes = [199, 201, 230, 250, 280, 299]
        
        try statusCodes.forEach { code in
            XCTAssertThrowsError(
                try CharacterFeedMapper.map(data: invalidData(), response: anyURLResponse(with: code))
            )
        }
    }
    
    func test_map_deliversErrorOn200HTTPResponseWithInvalidJSON() throws {
        XCTAssertThrowsError(
            try CharacterFeedMapper.map(data: invalidData(), response: anyURLResponse(with: 200))
        )
    }
    
    func test_map_deliversNoItemOnValidEmptyJSONWithHTTP200() throws {
        let data = emptyJSONData()
        let response = anyURLResponse(with: 200)
        
        let item = try CharacterFeedMapper.map(data: data, response: response)
        XCTAssertEqual(item.results, [], "Expects no item on empty json data")
    }
    
    func test_map_deliversItemOnValidJSONWithHTTP200Response() throws {
        let (data, model) = someJSONData()
        let response = anyURLResponse(with: 200)
        
        let item = try CharacterFeedMapper.map(data: data, response: response)
        XCTAssertEqual(item.results, [model], "Expects no item on empty json data")
    }
    
    //MARK: - Helpers
    
    private func anyURLResponse(with code: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}
