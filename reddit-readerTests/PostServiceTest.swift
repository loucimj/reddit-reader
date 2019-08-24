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
}
