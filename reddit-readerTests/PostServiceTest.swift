//
//  PostServiceTest.swift
//  RedditReader
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader


class PostServiceTest: XCTestCase {
    var httpClient: HTTPClient!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        httpClient = HTTPClient(session: session)
    }
    override func tearDown() {
        super.tearDown()
    }
    func test_emptyCollectionIsReceived() {
        session.mockedData = Data("""
            {
            }
        """.utf8)
        var returnedData: Data?
        let service = PostService(client: httpClient)
        service.getPosts() { data, error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
            returnedData = data
        }
        XCTAssertEqual(session.mockedData, returnedData, "The data should be equal to the expected values")
    }
    func test_serviceHasAnError() {
        session.mockedData = nil
        session.mockedError = PostServiceErrors.serviceReturnedEmtpyData
        var returnedError: Error?
        let service = PostService(client: httpClient)
        service.getPosts() { data, error in
            returnedError = error
        }
        XCTAssert(returnedError?.localizedDescription == session.mockedError?.localizedDescription, "The error should be equal to the expected values")
    }
}
