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
    internal var localDatabase = LocalDatabase(posts: Set<Post>(), readIds: [], removedIds: [])
    private var filesystemQueue: DispatchQueue = DispatchQueue(label: "fileSystemQueue")

    func initDatabase() {
        readLocalDatabaseFromFilesystem()
    }
    
    func addMorePosts(posts: [Post]) {
        for post in posts {
            if !self.localDatabase.posts.contains(post) {
                self.localDatabase.posts.insert(post)
            }
        }
        saveLocalDatabaseToFilesystem()
    }
    func markPostAsRead(post: Post) {
        self.localDatabase.readIds.insert(post.id)
        saveLocalDatabaseToFilesystem()
    }
    func removePost(post: Post) {
        self.localDatabase.posts.remove(post)
        self.localDatabase.readIds.remove(post.id)
        self.localDatabase.removedIds.insert(post.id)
        saveLocalDatabaseToFilesystem()
    }
    func removeAllPosts() {
        self.localDatabase.removedIds = self.localDatabase.removedIds.union(self.localDatabase.posts.map({ $0.id }))
        self.localDatabase.posts.removeAll()
        self.localDatabase.readIds.removeAll()
        saveLocalDatabaseToFilesystem()
    }
    
    private func saveLocalDatabaseToFilesystem() {
        self.filesystemQueue.sync { [weak self] in
            guard let self = self else { return }
            do {
                try self.localDatabase.saveToFile()
            } catch {
                print("Write to filesystem error \(error)")
            }
        }
    }
    private func readLocalDatabaseFromFilesystem() {
        self.filesystemQueue.sync { [weak self] in
            guard let self = self else { return }
            do {
                try self.localDatabase.readFromFile()
            } catch {
                print("Read from filesystem error \(error)")
            }
        }
    }
}
