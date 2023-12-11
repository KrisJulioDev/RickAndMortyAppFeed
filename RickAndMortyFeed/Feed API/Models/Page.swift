//
//  Page.swift
//  RickAndMortyFeed
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation

public class Page  {
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}

public class NextPage: Page { 
}
public class PreviousPage: Page {}
