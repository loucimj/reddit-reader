//
//  DetailViewController.swift
//  reddit-reader
//
//  Created by Javier Loucim on 22/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = post {
            if let label = detailDescriptionLabel {
                label.text = post?.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var post: Post? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

