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
        textView.text = post.content.rendered
        let url = URL(string: post.jetpack_featured_media_url ?? "")
        postImageView.kf.setImage(with: url)
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
