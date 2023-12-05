//
//  FeedEndpoint.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation

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

public class NextPage: Page {}
public class PrevPage: Page {}

public enum FeedEndpoint {
    case get(page: Page?)
    
    public var url: URL {
        switch self {
        case let .get(page):
            let initialURL = URL(string: "https://rickandmortyapi.com/api/character")!
            return page?.url ?? initialURL
        }
    }
}
