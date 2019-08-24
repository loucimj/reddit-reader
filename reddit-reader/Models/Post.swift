//
//  Post.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

struct Post: Codable {
    let id: String
    let title: String
    let author: String
    let commentsQuantity: Int
    let creationDateUTC: Double
    let thumbnail: String
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
}
