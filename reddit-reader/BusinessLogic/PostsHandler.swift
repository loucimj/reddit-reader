//
//  PostsHandler.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

enum PostHandlerErrors: Error {
    case noServiceIsProvided
    case noPostsAvailable
    case serviceResponseIsNotParseable
    case networkError
}
extension PostHandlerErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPostsAvailable:
            return NSLocalizedString("No posts available", comment:"")
        case .noServiceIsProvided:
            return NSLocalizedString("No post service is provided", comment:"")
        case .serviceResponseIsNotParseable:
            return NSLocalizedString("Response from service could not be parsed", comment:"")
        case .networkError:
            return NSLocalizedString("Network Error", comment:"")
        }
    }
}

protocol PostsHandler: class {
    var postService: PostService? { get set }
    func didReceive(posts: [Post])
    func postHandlerHasAnError(error: Error)
}

extension PostsHandler {
    
    func getMorePosts() {
        guard let service = postService else {
            postHandlerHasAnError(error: PostHandlerErrors.noServiceIsProvided)
            return
        }
        service.getPosts() { [weak self] data, error in
            guard let self = self else { return }
            guard error == nil else {
                self.postHandlerHasAnError(error: error!)
                return
            }
            guard let data = data else {
                self.postHandlerHasAnError(error: PostHandlerErrors.serviceResponseIsNotParseable)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary: [String: Any] = json as? [String: Any] else {
                    self.postHandlerHasAnError(error: PostHandlerErrors.serviceResponseIsNotParseable)
                    return
                }
                guard let postsDictionary = (dictionary["data"] as? [String: Any])?["children"] as? [[String: Any]] else {
                    self.postHandlerHasAnError(error: PostHandlerErrors.serviceResponseIsNotParseable)
                    return
                }
                var posts: Set<Post> = []
                for item in postsDictionary {
                    do {
                        if let dataDictionary = item["data"] as? [String: Any] {
                            let post = try Post(dictionary: dataDictionary)
                            print("\(post)")
                            posts.insert(post)
                        }
                    } catch {
                        print("\(error)")
                    }
                }
                #warning("merge data before assigning to singleton")
                ApplicationData.shared.posts = posts
            } catch {
                self.postHandlerHasAnError(error: PostHandlerErrors.serviceResponseIsNotParseable)
            }
            #warning("Store data locally and merge with previous information")
            self.readPosts()
        }
    }
    func readPosts() {
        guard let posts = ApplicationData.shared.posts else {
            postHandlerHasAnError(error: PostHandlerErrors.noPostsAvailable)
            return
        }
        didReceive(posts: posts.sorted(by: { $0.creationDateUTC < $1.creationDateUTC }))
    }
    
}
