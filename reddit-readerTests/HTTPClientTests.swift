//
//  HTTPClientTests.swift
//  reddit-readerTests
//
//  Created by Javier Loucim on 23/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader

class MockURLSessionDataTask {
    func resume() { }
}

class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}

class HTTPClientTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetRequest() {
        
    }

}
