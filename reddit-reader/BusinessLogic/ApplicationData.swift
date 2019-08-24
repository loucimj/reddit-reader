//
//  ApplicationData.swift
//  RedditReader
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

class ApplicationData {
    static let redditURLString: String = "https://www.reddit.com/top/.json?count=50"
    static var shared = ApplicationData()
    var posts: [Post]?
}
