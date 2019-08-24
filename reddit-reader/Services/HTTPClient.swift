//
//  HTTPClient.swift
//  reddit-reader
//
//  Created by Javier Loucim on 23/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//  based on http://masilotti.com/testing-nsurlsession-input/
//

import Foundation

public protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

class HTTPClient {
    typealias completionClosure = ( _ data: Data?, _ error: Error?) -> Void
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func get( url: URL, callback: @escaping completionClosure ) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
    }
}
