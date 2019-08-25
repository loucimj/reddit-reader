//
//  PostTableViewCell.swift
//  RedditReader
//
//  Created by Javier Loucim on 25/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var unreadIndicatorView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with post: Post) {
        unreadIndicatorView.layer.cornerRadius = unreadIndicatorView.bounds.height/2
        unreadIndicatorView.layer.masksToBounds = true
        unreadIndicatorView.backgroundColor = UIColor.unreadColor
        authorLabel.text = post.author
        timeAgoLabel.text = post.timeAgo
        commentsLabel.text = post.commentsText
        titleLabel.text = post.title
    }
    
}
