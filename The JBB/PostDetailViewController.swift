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
    
    // MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
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
        headerView.addTopDownGradient(color: UIColor(named: "Teel")!.cgColor)
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
