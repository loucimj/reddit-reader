//
//  ApplicationDataTests.swift
//  RedditReaderTests
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader

class ApplicationDataTests: XCTestCase {
    var post: Post?
    var secondPost: Post?
    override func setUp() {
        super.setUp()
        do {
            post = try PostsMother.defaultPost()
            secondPost = try PostsMother.secondPost()
            ApplicationData.shared.posts = nil
       } catch {
            print("\(error)")
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_addNewPostToEmptyData() {
        guard let post = self.post else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.addMorePosts(posts: [post])
        XCTAssertEqual(ApplicationData.shared.posts?.count, 1, "There should be one post")
    }

    func test_addNewPostToActualData() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.addMorePosts(posts: [post])
        ApplicationData.shared.addMorePosts(posts: [secondPost])
        XCTAssertEqual(ApplicationData.shared.posts?.count, 2, "There should be two posts")
    }
    func test_addPostThatAlreadyExists() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.addMorePosts(posts: [post])
        ApplicationData.shared.addMorePosts(posts: [secondPost])
        ApplicationData.shared.addMorePosts(posts: [post])
        XCTAssertEqual(ApplicationData.shared.posts?.count, 2, "There should be two posts")
    }

}
