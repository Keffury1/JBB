//
//  PostTableViewCell.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit

protocol PostTVCellDelegate {
    func buttonTapped(int: Int)
}

class PostTableViewCell: UITableViewCell {

    
    //MARK: - Properties
    
    var postTVCellDelegate: PostTVCellDelegate?
    var indexPath: IndexPath?
    
    //MARK: - Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var imageViewContainer: UIView!
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupSubviews() {
        containerView.layer.cornerRadius = 10
        containerView.addShadow()
        postButton.setTitle("", for: .normal)
    }

    @IBAction func postButtonTapped(_ sender: Any) {
        postTVCellDelegate?.buttonTapped(int: indexPath!.row)
    }
}
