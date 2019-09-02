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
            ApplicationData.shared.localDatabase.posts = []
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
        resetDatabase()
        ApplicationData.shared.addMorePosts(posts: [post])
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 1, "There should be one post")
    }

    func test_addNewPostToActualData() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        resetDatabase()
        ApplicationData.shared.addMorePosts(posts: [post])
        ApplicationData.shared.addMorePosts(posts: [secondPost])
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 2, "There should be two posts")
    }
    func test_addPostThatAlreadyExists() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        resetDatabase()
        ApplicationData.shared.addMorePosts(posts: [post])
        ApplicationData.shared.addMorePosts(posts: [secondPost])
        ApplicationData.shared.addMorePosts(posts: [post])
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 2, "There should be two posts")
    }
    func test_addPostThatWasDeleted() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.localDatabase.removedIds = []
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.addMorePosts(posts: [post])
        ApplicationData.shared.addMorePosts(posts: [secondPost])
        ApplicationData.shared.removePost(post: post)
        ApplicationData.shared.addMorePosts(posts: [post])
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 1, "There should be only one post")
    }
    func test_databaseInitialization() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        resetDatabase()
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        resetDatabase()
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.isEmpty, true, "The database should be empty")
        ApplicationData.shared.initDatabase()
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 2, "There should be two posts")
        ApplicationData.shared.removePost(post: secondPost)
        resetDatabase()
        ApplicationData.shared.initDatabase()
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 1, "There should be only one post")
        resetDatabase()
        ApplicationData.shared.initDatabase()
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        XCTAssertEqual(ApplicationData.shared.localDatabase.posts.count, 1, "There should be only one post")
    }
    func resetDatabase() {
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.removedIds = []
    }
}
