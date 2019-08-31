//
//  MasterViewControllerTests.swift
//  RedditReader
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader

class MasterViewControllerTests: XCTestCase {
    var httpClient: HTTPClient!
    let session = MockURLSession()
    var viewController:MasterViewController!
    var topLevelUIUtilities: TopLevelUIUtilities<MasterViewController>!

    override func setUp() {
        super.setUp()
        session.mockedData = PostsMother.responseMockedData()
        session.mockedError = nil
        httpClient = HTTPClient(session: session)

        ApplicationData.shared.localDatabase.removedIds.removeAll()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "MasterViewController") as? MasterViewController
        viewController.postService = PostService(client: httpClient)

        topLevelUIUtilities = TopLevelUIUtilities<MasterViewController>()
        topLevelUIUtilities.setupTopLevelUI(withViewController: viewController)
    }
    override func tearDown() {
        super.tearDown()
        topLevelUIUtilities.tearDownTopLevelUI()
    }
    func test_tableviewShowsRowsAccordingToResponse() {
        let postsExpectation = expectation(description: "expectation")
        DispatchQueue.main.async {
            XCTAssert(self.viewController.posts.count > 0, "There should be more than one post")
            XCTAssert(self.viewController.tableView.numberOfRows(inSection: 0) == self.viewController.posts.count, "The cells don't match the quantity of posts")
            postsExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
