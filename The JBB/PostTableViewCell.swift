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
    var postCategories: [String]?
    
    //MARK: - Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var backupImageView: UIImageView!
    @IBOutlet weak var categoriesHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupSubviews() {
        categoriesCollectionView.dataSource = self
        containerView.layer.cornerRadius = 10
        containerView.addShadow()
        postButton.setTitle("", for: .normal)
    }

    @IBAction func postButtonTapped(_ sender: Any) {
        postTVCellDelegate?.buttonTapped(int: indexPath!.row)
    }
}

extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if postCategories?.count == 1 {
            categoriesHeightConstraint.constant = 0
        } else {
            categoriesHeightConstraint.constant = 35
        }
        return postCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }

        if postCategories?.count ?? 0 > indexPath.row {
            cell.containerView.layer.cornerRadius = 8
            cell.categoryTitleLabel.text = postCategories?[indexPath.row]
        }
        
        return cell
    }
}
