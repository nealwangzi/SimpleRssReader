//
//  NewsTableViewCell.swift
//  simpleRssReader
//
//  Created by neal on 2017/6/29.
//  Copyright © 2017年 Cloudoc. All rights reserved.
//

import UIKit

enum CellState {
    case expanded
    case collapsed
}
class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 4
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
