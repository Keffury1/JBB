//
//  PodcastTableViewCell.swift
//  JBB
//
//  Created by Bobby Keffury on 8/31/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class PodcastTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var minutesRemainingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
