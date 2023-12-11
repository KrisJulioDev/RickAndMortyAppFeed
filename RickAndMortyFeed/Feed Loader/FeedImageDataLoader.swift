//
//  FeedImageDataLoader.swift
//  RickAndMortyApp
//
//  Created by Khristoffer Julio on 12/8/23.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
