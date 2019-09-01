//
//  PhotoSaver.swift
//  RedditReader
//
//  Created by Javier Loucim on 31/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation
import Photos

protocol PhotoSaver {
    func photoSaveHasAnError(error: Error)
    func didSavePhoto()
}

extension PhotoSaver {
    func didSavePhoto() {}
    func photoSaveHasAnError(error: Error) {}
    
    func savePhoto(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                DispatchQueue.main.async {
                    self.didSavePhoto()
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.photoSaveHasAnError(error: error)
                }
            }
        })
    }
}
