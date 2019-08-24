//
//  PostService.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

public enum PostServiceErrors: Error {
    case serviceReturnedEmtpyData
}
extension PostServiceErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceReturnedEmtpyData:
            return NSLocalizedString("The reddit service returned empty data", comment: "PostService error")
        }
    }
}

class PostService {
    private var client: HTTPClient
    init(client: HTTPClient = HTTPClient()) {
        self.client = client
    }
    func getPosts(completionClosure: @escaping HTTPClient.completionClosure) {
        guard let url = URL(string: ApplicationData.redditURLString) else { return }
        client.get(url: url) { data , error in
            guard error == nil else {
                completionClosure(nil, error)
                return
            }
            guard let data = data else {
                completionClosure(nil, PostServiceErrors.serviceReturnedEmtpyData)
                return
            }
            completionClosure(data, nil)
        }
    }
}
