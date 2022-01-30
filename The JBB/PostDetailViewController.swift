//
//  PostDetailViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit

class PostDetailViewController: UIViewController {

    // MARK: - Properties
    
    var post: Post?
    var categories: [String]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        categoriesCollectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let post = post else { return }
        let string = post.title.rendered.replacingOccurrences(of: "&#8211;", with: "-", options: .literal, range: nil)
        let replaced = string.replacingOccurrences(of: "&#038;", with: "&", options: .literal, range: nil)
        titleLabel.text = replaced.capitalized
        textView.text = post.content.rendered.html2String
        let url = URL(string: post.jetpack_featured_media_url ?? "")
        postImageView.kf.setImage(with: url)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let someDateTime = dateFormatter.date(from: post.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            let date = formatter.string(from: someDateTime)
            dateLabel.text = date
        } else {
            dateLabel.text = ""
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        if categories?.count ?? 0 > indexPath.row {
            cell.containerView.layer.cornerRadius = 8
            cell.categoryTitleLabel.text = categories?[indexPath.row]
        }
        
        return cell
    }
}
