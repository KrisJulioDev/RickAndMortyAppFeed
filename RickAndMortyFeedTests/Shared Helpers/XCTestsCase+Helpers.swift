//
//  XCTestsCase+Helpers.swift
//  RickAndMortyFeedTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation

func anyURL() -> URL { URL(string: "any-url")! }

func invalidData() -> Data { Data("invalid-data".utf8) }

func anyError() -> NSError { NSError(domain: "err", code: 0) }
