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
    var localDatabase = LocalDatabase(posts: Set<Post>(), readIds: [])
    
    func initDatabase() {
        readLocalDatabaseFromFilesystem()
    }
    
    func addMorePosts(posts: [Post]) {
        self.localDatabase.posts = self.localDatabase.posts.union(posts)
        saveLocalDatabaseToFilesystem()
    }
    func markPostAsRead(post: Post) {
        self.localDatabase.readIds.insert(post.id)
        saveLocalDatabaseToFilesystem()
    }
    private var filesystemQueue: DispatchQueue = DispatchQueue(label: "fileSystemQueue")
    
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
