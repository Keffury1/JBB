//
//  ArticleTableViewCell.swift
//  JBB
//
//  Created by Bobby Keffury on 5/1/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBAction func exportButtonTapped(_ sender: Any) {
        
    }
    
}
