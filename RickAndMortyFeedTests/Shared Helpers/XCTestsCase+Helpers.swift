//
//  XCTestsCase+Helpers.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import RickAndMortyFeed
import XCTest

func anyURL() -> URL { URL(string: "any-url")! }

func invalidData() -> Data { Data("invalid-data".utf8) }

func anyError() -> NSError { NSError(domain: "err", code: 0) }

func feedCharacters() -> (model: [CharacterItem], local: [LocalCharacter]) {
    
    let model = [CharacterItem(id: 1, name: "", status: "", species: "", type: "", gender: "", image: nil)]

    let local = [LocalCharacter(id: 1, name: "", status: "", species: "", type: "", gender: "", image: nil)]
    
    return (model, local)
} 

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be nil, potential memory leaks", file: file, line: line)
        }
    }
}
