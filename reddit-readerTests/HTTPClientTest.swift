//
//  reddit_readerTests.swift
//  reddit-readerTests
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest
@testable import RedditReader

class MockURLSessionDataTask: URLSessionDataTask  {
    override func resume() {
        print("empty resume for dataTask")
    }
}

class MockURLSession: URLSessionProtocol {
    private (set) var lastURL: URL?
    func dataTask(with request: URLRequest, completionHandler: @escaping MockURLSession.DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        return MockURLSessionDataTask()
    }
}

class HTTPClientTests: XCTestCase {
    
    var httpClient: HTTPClient!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        httpClient = HTTPClient(session: session)
    }
    override func tearDown() {
        super.tearDown()
    }
    func test_URLisSetProperly() {
        guard let url = URL(string: "http://apple.com") else {
            XCTFail("Cannot construct testing URL")
            return
        }
        httpClient.get(url: url) { data, error in
            print("HTTPClient returns data")
        }
        XCTAssert(url.absoluteString == (self.session.lastURL?.absoluteString ?? ""), "The last request done by the client should be present in the session")
    }
}
