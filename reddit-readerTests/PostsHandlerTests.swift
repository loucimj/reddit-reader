//
//  PostsHandlerTests.swift
//  RedditReaderTests
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader

class MockPostsConsumer: PostsHandler {
    var postService: PostService?
    var successCallback: (([Post])->())?
    var errorCallback: ((Error)->())?
    var readPostCallback: ((Post)->())?
    var removePostCallback: ((Post)->())?
    var didRemoveAllPostsCallback: (()->())?
    var didFetchMorePostsCallback: (()->())?

    func didReceive(posts: [Post]) {
        successCallback?(posts)
    }
    
    func postHandlerHasAnError(error: Error) {
        errorCallback?(error)
    }
    
    func didMarkPostAsRead(post: Post) {
        readPostCallback?(post)
    }
    func didFetchMorePosts() {
        didFetchMorePostsCallback?()
    }
    
    func didRemove(post: Post) {
        removePostCallback?(post)
    }
    func didRemoveAllPosts() {
        didRemoveAllPostsCallback?()
    }
}

class PostsHandlerTests: XCTestCase {
    var httpClient: HTTPClient!
    let session = MockURLSession()
    var consumer1 = MockPostsConsumer()
    var post: Post?
    var secondPost: Post?
    var mockedData = Data("""
            {
                "kind": "Listing",
                "data": {
                    "modhash": "uo8ez9e1lf807810187b428b01e59cd38a9303245aa595d992",
                    "children": [
                        {
                            "kind": "t3",
                            "data": {
                                "domain": "i.imgur.com",
                                "banned_by": null,
                                "media_embed": {},
                                "subreddit": "funny",
                                "selftext_html": null,
                                "selftext": "",
                                "likes": null,
                                "user_reports": [],
                                "secure_media": null,
                                "link_flair_text": null,
                                "id": "2hqlxp",
                                "gilded": 0,
                                "secure_media_embed": {},
                                "clicked": false,
                                "report_reasons": null,
                                "author": "washedupwornout",
                                "media": null,
                                "score": 4841,
                                "approved_by": null,
                                "over_18": false,
                                "hidden": false,
                                "thumbnail": "http://b.thumbs.redditmedia.com/9N1f7UGKM5fPZydrsgbb4_SUyyLW7A27um1VOygY3LM.jpg",
                                "subreddit_id": "t5_2qh33",
                                "edited": false,
                                "link_flair_css_class": null,
                                "author_flair_css_class": null,
                                "downs": 0,
                                "mod_reports": [],
                                "saved": false,
                                "is_self": false,
                                "name": "t3_2hqlxp",
                                "permalink": "/r/funny/comments/2hqlxp/man_trying_to_return_a_dogs_toy_gets_tricked_into/",
                                "stickied": false,
                                "created": 1411975314,
                                "url": "http://i.imgur.com/4CHXnj2.gif",
                                "author_flair_text": null,
                                "title": "Man trying to return a dog's toy gets tricked into playing fetch",
                                "created_utc": 1411946514,
                                "ups": 4841,
                                "num_comments": 958,
                                "visited": false,
                                "num_reports": null,
                                "distinguished": null
                            }
                        },
                        {
                            "kind": "t3",
                            "data": {
                                "domain": "alphagalileo.org",
                                "banned_by": null,
                                "media_embed": {},
                                "subreddit": "science",
                                "selftext_html": null,
                                "selftext": "",
                                "likes": null,
                                "user_reports": [],
                                "secure_media": null,
                                "link_flair_text": "Social Sciences",
                                "id": "2hozly",
                                "gilded": 0,
                                "secure_media_embed": {},
                                "clicked": false,
                                "report_reasons": null,
                                "author": "mubukugrappa",
                                "media": null,
                                "score": 4498,
                                "approved_by": null,
                                "over_18": false,
                                "hidden": false,
                                "thumbnail": "",
                                "subreddit_id": "t5_mouw",
                                "edited": false,
                                "link_flair_css_class": "soc",
                                "author_flair_css_class": null,
                                "downs": 0,
                                "mod_reports": [],
                                "saved": false,
                                "is_self": false,
                                "name": "t3_2hozly",
                                "permalink": "/r/science/comments/2hozly/the_secret_to_raising_well_behaved_teens_maximise/",
                                "stickied": false,
                                "created": 1411937584,
                                "url": "http://www.alphagalileo.org/ViewItem.aspx?ItemId=145707&amp;CultureCode=en",
                                "author_flair_text": null,
                                "title": "The secret to raising well behaved teens? Maximise their sleep: While paediatricians warn sleep deprivation can stack the deck against teenagers, a new study reveals youth’s irritability and laziness aren’t down to attitude problems but lack of sleep",
                                "created_utc": 1411908784,
                                "ups": 4498,
                                "num_comments": 3740,
                                "visited": false,
                                "num_reports": null,
                                "distinguished": null
                            }
                        }
                    ],
                    "after": "t3_2hpw7k",
                    "before": null
                }
            }
        """.utf8)
    override func setUp() {
        super.setUp()
        httpClient = HTTPClient(session: session)
        ApplicationData.shared.localDatabase.removedIds.removeAll()
        do {
            post = try PostsMother.defaultPost()
            secondPost = try PostsMother.secondPost()
        } catch {
            
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_parsesDataProperly() {
        let postsExpectation = expectation(description: "PostsHandler expectation")

        session.mockedData = mockedData
        session.mockedError = nil
        let service = PostService(client: httpClient)
        consumer1.postService = service
        consumer1.didFetchMorePostsCallback = {
            self.consumer1.readPosts()
        }
        consumer1.successCallback = { posts in
            guard !posts.isEmpty else {
                XCTFail("posts collection is empty")
                return
            }
            postsExpectation.fulfill()
        }
        consumer1.errorCallback = { error in
            XCTFail(error.localizedDescription)
        }
        consumer1.getMorePosts()
        waitForExpectations(timeout: 1)
    }
    
    func test_noDataIsReturnedIfNetworkIsNotPresent() {
        session.mockedData = nil
        session.mockedError = PostHandlerErrors.networkError
        ApplicationData.shared.localDatabase.posts = []
        let service = PostService(client: httpClient)
        let postsExpectation = expectation(description: "PostsHandler expectation")
        consumer1.postService = service
        consumer1.successCallback = { posts in
            XCTFail("Service should throw an error")
        }
        consumer1.errorCallback = { error in
            print("\(error)")
            switch error {
            case PostHandlerErrors.networkError:
                postsExpectation.fulfill()
            default:
                XCTFail("The error is not what is expected")
            }
        }
        consumer1.getMorePosts()
        waitForExpectations(timeout: 1)

    }

    func test_markPostAsRead() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }

        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        
        let service = PostService(client: httpClient)
        let postsExpectation = expectation(description: "PostsHandler expectation")
        consumer1.postService = service
        consumer1.readPostCallback = { post in
            XCTAssertTrue(ApplicationData.shared.localDatabase.readIds.contains(secondPost.id), "The id should be mark as read")
            postsExpectation.fulfill()
        }
        consumer1.errorCallback = { error in
            XCTFail("Service should throw an error")
        }
        consumer1.markPostAsRead(post: secondPost)

        waitForExpectations(timeout: 5)

    }
    func test_postIsStillMarkedAsRead() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        
        let service = PostService(client: httpClient)
        consumer1.postService = service
        consumer1.readPostCallback = { post in

        }
        consumer1.errorCallback = { error in
            XCTFail("Service should not throw an error")
        }
        consumer1.markPostAsRead(post: secondPost)
        
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.initDatabase()
        XCTAssertTrue(ApplicationData.shared.localDatabase.readIds.contains(secondPost.id), "The id should be mark as read")
    }
    
    func test_readPostsReturnsPostsWithReadMarks() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        let postsExpectation = expectation(description: "PostsHandler expectation")
        let service = PostService(client: httpClient)
        consumer1.postService = service
        consumer1.successCallback = { posts in
            guard let postReference = posts.filter({ $0.id == secondPost.id}).first else {
                XCTFail("Post not found")
                return
            }
            XCTAssert(postReference.isRead, "The post should be marked as read")
            postsExpectation.fulfill()
        }
        consumer1.errorCallback = { error in
            XCTFail("Service should not throw an error")
        }
        consumer1.markPostAsRead(post: secondPost)
        consumer1.readPosts()
        waitForExpectations(timeout: 1)
    }
    func test_removePost() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        let postsExpectation = expectation(description: "PostsHandler expectation")
        let service = PostService(client: httpClient)
        consumer1.postService = service
        consumer1.removePostCallback = { post in
            XCTAssert(ApplicationData.shared.localDatabase.posts.contains(secondPost) == false, "The post should have been removed")
            postsExpectation.fulfill()
        }
        consumer1.errorCallback = { error in
            XCTFail("Service should not throw an error")
        }
        consumer1.removePost(post:secondPost)
        waitForExpectations(timeout: 1)
    }
    func test_removePostAndAdditLaterAgain() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        session.mockedData = mockedData
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.localDatabase.removedIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        ApplicationData.shared.removePost(post: post)
        ApplicationData.shared.removePost(post: secondPost)
        let postsExpectation = expectation(description: "PostsHandler expectation")
        let service = PostService(client: httpClient)
        consumer1.postService = service
        consumer1.successCallback = { posts in
            XCTAssert(posts.contains(post) == false, "The post was removed and should not be returned again")
            XCTAssert(posts.contains(secondPost) == false, "The secondPost was removed and should not be returned again")
            postsExpectation.fulfill()
        }
        consumer1.errorCallback = { error in
            XCTFail("Service should not throw an error")
        }
        consumer1.readPosts()
        waitForExpectations(timeout: 1)

    }
    func test_removeAllPosts() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.localDatabase.removedIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        let postsExpectation = expectation(description: "PostsHandler expectation")
        let service = PostService(client: httpClient)
        consumer1.postService = service
        consumer1.errorCallback = { error in
            XCTFail("Service should not throw an error")
        }
        consumer1.didRemoveAllPostsCallback = {
            XCTAssert(ApplicationData.shared.localDatabase.posts.isEmpty, "The database should be empty")
            postsExpectation.fulfill()
        }
        consumer1.removeAllPosts()
        waitForExpectations(timeout: 1)
    }
    func test_removeAllPostsAndFetchAgain() {
        guard let post = self.post, let secondPost = secondPost else {
            XCTFail("couldnt initialize post data")
            return
        }
        ApplicationData.shared.localDatabase.posts = []
        ApplicationData.shared.localDatabase.readIds = []
        ApplicationData.shared.localDatabase.removedIds = []
        ApplicationData.shared.addMorePosts(posts: [post, secondPost])
        let postsExpectation = expectation(description: "PostsHandler expectation")
        let service = PostService(client: httpClient)
        consumer1.postService = service
        session.mockedData = mockedData
        consumer1.errorCallback = { error in
            XCTFail("Service should not throw an error")
        }
        consumer1.didRemoveAllPostsCallback = {
            self.consumer1.readPosts()
        }
        consumer1.successCallback = { posts in
            XCTAssert(posts.isEmpty, "The database should be empty")
            postsExpectation.fulfill()
        }
        consumer1.removeAllPosts()
        waitForExpectations(timeout: 1)
    }
}
