//
//  XCTestsCase+Helpers.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/7/23.
//

import XCTest
import RickAndMortyFeed

public func anyInfo() -> Info {
    Info(count: 1, pages: 2, next: "next", prev: "prev")
}

public func anyFeedCharacters() -> (model: [CharacterItem], local: [LocalCharacter]) {
    
    let model = [CharacterItem(id: 1, name: "model-1", status: "alive", species: "", type: "", gender: "", image: URL(string: "any")!, location: "earth", origin: "mars")]

    let local = [LocalCharacter(id: 1, name: "model-1", status: "alive", species: "", type: "", gender: "", image: URL(string: "any")!, location: "mars", origin: "earth")]
    
    return (model, local)
}

extension XCTestCase {
    func trackMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be nil, potential memory leaks", file: file, line: line)
        }
    }
}
