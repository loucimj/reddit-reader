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
    func didMarkPostAsRead(post: Post)
    func didRemove(post: Post)
    func didRemoveAllPosts()
    func postHandlerHasAnError(error: Error)
}

extension PostsHandler {
    func didMarkPostAsRead(post: Post) {}
    func didRemove(post: Post) {}
    func didRemoveAllPosts() {}
    
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
                var posts: Array<Post> = []
                for item in postsDictionary {
                    do {
                        if let dataDictionary = item["data"] as? [String: Any] {
                            let post = try Post(dictionary: dataDictionary)
                            if !ApplicationData.shared.localDatabase.removedIds.contains(post.id) {
                                posts.append(post)
                            }
                        }
                    } catch {
                        print("\(error)")
                    }
                }
                ApplicationData.shared.addMorePosts(posts: posts)
            } catch {
                self.postHandlerHasAnError(error: PostHandlerErrors.serviceResponseIsNotParseable)
            }
            self.readPosts()
        }
    }
    func readPosts() {
        let posts = ApplicationData.shared.localDatabase.posts.map({ (post: Post) -> Post in
            var newPost = post
            newPost.isRead = ApplicationData.shared.localDatabase.readIds.contains(post.id)
            return newPost
        })
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.didReceive(posts: posts.sorted(by: { $0.creationDateUTC < $1.creationDateUTC }))
        }
        
    }
    func markPostAsRead(post: Post) {
        ApplicationData.shared.markPostAsRead(post: post)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.didMarkPostAsRead(post: post)
        }
    }
    func removePost(post: Post) {
        ApplicationData.shared.removePost(post: post)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.didRemove(post: post)
        }
        
    }
    func removeAllPosts() {
        ApplicationData.shared.removeAllPosts()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.didRemoveAllPosts()
        }
    }
}
