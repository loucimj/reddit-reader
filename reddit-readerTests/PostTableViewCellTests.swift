//
//  PostTableViewCellTests.swift
//  RedditReaderTests
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader

extension PostTableViewCell: NibLoadable {
    
}

class PostTableViewCellTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_allFieldsAreRenderedProperly() {
        let cell = PostTableViewCell.loadFromNib()
        do {
            let post = try PostsMother.defaultPost()
            cell.configure(with: post)
            XCTAssert(cell.authorLabel.text == post.author, "Author should be present")
            XCTAssert(cell.commentsLabel.text == post.commentsText, "Comments should be present")
            XCTAssert(cell.timeAgoLabel.text == post.timeAgo, "time ago should be present")
            XCTAssert(cell.titleLabel.text == post.title, "title should be present")
            XCTAssert(cell.unreadIndicatorView.isHidden == post.isRead, "uread indicator should be present only if post is unread")
        } catch {
            XCTFail("Mocked post couldnt be created")
            return
        }
    }

}
