//
//  Post.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

struct Post: Codable, Hashable {
    let id: String
    let title: String
    let author: String
    let commentsQuantity: Int
    let creationDateUTC: Double
    let thumbnail: String
    var isRead: Bool = false
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case author = "author"
        case commentsQuantity = "num_comments"
        case creationDateUTC = "created_utc"
        case thumbnail = "thumbnail"
    }
    init(dictionary: [String: Any]) throws {
        self = try JSONDecoder().decode(Post.self, from: JSONSerialization.data(withJSONObject: dictionary))
    }
}
extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
extension Post: CustomStringConvertible {
    var description: String {
        return "[" + id + "] " + title
    }
}
