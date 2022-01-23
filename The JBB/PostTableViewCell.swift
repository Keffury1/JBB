//
//  PostTableViewCell.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    //MARK: - Outlets

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
