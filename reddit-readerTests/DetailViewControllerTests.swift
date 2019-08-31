//
//  DetailViewControllerTests.swift
//  RedditReaderTests
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import XCTest

@testable import RedditReader

class DetailViewControllerTests: XCTestCase {
    var post: Post?
    var viewController: DetailViewController!
    var topLevelUIUtilities: TopLevelUIUtilities<DetailViewController>!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        do {
            post = try PostsMother.defaultPost()
        } catch {
            print("\(error)")
        }
        topLevelUIUtilities = TopLevelUIUtilities<DetailViewController>()
        topLevelUIUtilities.setupTopLevelUI(withViewController: viewController)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_allFieldsAreRendered() {
        guard let post = post else {
            XCTFail("there should be a post")
            return
        }
        viewController.post = post
        XCTAssert(viewController.authorLabel.text == post.author, "The author should appear on the view controller")
        XCTAssert(viewController.detailDescriptionLabel.text == post.description, "The description should be visible")
        
    }

}
