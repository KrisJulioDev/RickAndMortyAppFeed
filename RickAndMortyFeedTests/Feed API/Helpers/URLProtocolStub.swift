//
//  URLProtocolStub.swift
//  RickMortyAppTests
//
//  Created by Khristoffer Julio on 12/5/23.
//

import Foundation

class URLProtocolStub: URLProtocol {
    private struct Stub {
        let data: Data?
        let error: Error?
        let response: URLResponse?
        let requestObserver: ((URLRequest) -> Void)?
    }
    
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }
    
    private static let queue = DispatchQueue(label: "urlprotocol.queue")
    
    static func stub(with data: Data?, error: Error?, response: URLResponse?) {
        stub = Stub(data: data, error: error, response: response, requestObserver: nil)
    }
    
    static func observeRequest(_ request: @escaping (URLRequest) -> Void) {
        stub = Stub(data: nil, error: nil, response: nil, requestObserver: request)
    }
    
    static func removeStub() {
        stub = nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override func startLoading() {
        guard let stub = URLProtocolStub.stub else { return }
        
        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
        
        stub.requestObserver?(request)
    }
    
    override func stopLoading() {}
}
