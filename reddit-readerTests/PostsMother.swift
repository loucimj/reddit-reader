//
//  PostsMother.swift
//  RedditReaderTests
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

@testable import RedditReader

class PostsMother {
    class func defaultPost() throws -> Post {
        return try JSONDecoder().decode(Post.self, from: Data("""
            {
                "id": "2hqlxp",
                "title": "title",
                "author" : "author",
                "num_comments": 4,
                "created_utc": 1411946514,
                "thumbnail": "http://something"
            }
        """.utf8))
    }
    class func secondPost() throws -> Post {
        return try JSONDecoder().decode(Post.self, from: Data("""
            {
                "id": "2hozly",
                "title": "title",
                "author" : "author",
                "num_comments": 4,
                "created_utc": 1411946514,
                "thumbnail": "http://something"
            }
        """.utf8))
    }
}
