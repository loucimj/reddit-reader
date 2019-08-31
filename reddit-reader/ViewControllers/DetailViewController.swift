//
//  DetailViewController.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: Post? {
        didSet {
            configureViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViews()
    }


    // MARK: - Functions
    func configureViews() {
        guard let post = post else { return }
        guard detailDescriptionLabel != nil else { return }
        postImageView.backgroundColor = UIColor.gray
        postImageView.contentMode = .scaleAspectFill
        detailDescriptionLabel.text = post.description
        authorLabel.text = post.author
        if let url = post.thumbnailURL {
            postImageView.downloadImageFromUrl(url, defaultImage: nil)
        }
    }
    


}

