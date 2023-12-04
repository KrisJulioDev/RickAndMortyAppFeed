//
//  URLSessionHTTPClient.swift
//  RickMortyApp
//
//  Created by Khristoffer Julio on 12/4/23.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public struct InvalidDataRepresentation: Error {}
     
    public func get(url: URL, completion: (@escaping (HTTPClient.Result) -> Void)) -> HTTPClientTask {
        let task = session
            .dataTask(with: url) { data, response, error in
                completion( Result {
                    if let error {
                        throw error
                    } else if let data, let response = response as? HTTPURLResponse {
                        return (data, response)
                    } else {
                        throw InvalidDataRepresentation()
                    }
                })
            }
        
        task.resume()
        return URLSessionDataTaskWrapper(wrapped: task)
    }
}
