//
//  LocalDatabase.swift
//  RedditReader
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation
struct LocalDatabase: Codable {
    var posts: Set<Post>
}

extension LocalDatabase: Storable {
    mutating func initFromData(data: Data) throws {
        let decoder = JSONDecoder()
        let parsedData = try decoder.decode(LocalDatabase.self, from: data)
        self = parsedData
    }
    var storableFileName: String {
        return "localDatabase.json"
    }
}
