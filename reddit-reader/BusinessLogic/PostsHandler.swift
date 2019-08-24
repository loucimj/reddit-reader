//
//  PostsHandler.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

protocol PostsHandler {
    
    func postsHaveArrived(posts: [Post])
}

extension PostsHandler {
    
    func getMorePosts() {
        //read posts from the service
        //store data locally
        readPosts()
    }
    func readPosts() {
        //get from saved posts
        postsHaveArrived(posts: [])
    }
    
}
