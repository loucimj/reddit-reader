//
//  UIImageView+URL.swift
//  RedditReader
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//
//  based on https://gist.github.com/andrea-prearo/25da628120a29688bdc708629901fca4#file-downloadimagefromurl-swift

import Foundation
import UIKit

extension UIImageView {
    
    func downloadImageFromUrl(_ url: URL, defaultImage: UIImage? = nil) {
        DispatchQueue.main.async {
            self.image = defaultImage
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) -> Void in
            guard let self = self else { return }
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }).resume()
    }
    
}
