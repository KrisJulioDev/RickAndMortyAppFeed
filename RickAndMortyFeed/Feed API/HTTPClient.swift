//
//  HTTPClient.swift
//  RickMortyApp
//
//  Created by Khristoffer Julio on 12/4/23.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    @discardableResult
    func get(url: URL, completion: (@escaping (HTTPClient.Result) -> Void)) -> HTTPClientTask
}
