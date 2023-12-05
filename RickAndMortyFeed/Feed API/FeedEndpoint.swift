//
//  FeedEndpoint.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation


public enum FeedEndpoint {
    case get(_ page: Page? = nil)
    
    public static var initialURL: URL { URL(string: "https://rickandmortyapi.com/api/character")! }

    public var url: URL {
        switch self {
        case let .get(page):
            return page?.url ?? Self.initialURL
        }
    }
}
