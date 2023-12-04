//
//  HTTPClientTask.swift
//  RickMortyApp
//
//  Created by Khristoffer Julio on 12/4/23.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public struct URLSessionDataTaskWrapper: HTTPClientTask {
    let wrapped: URLSessionTask
    
    public func cancel() {
        wrapped.cancel()
    }
}
