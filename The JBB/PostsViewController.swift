//
//  PostsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/29/22.
//

import UIKit
import Kingfisher

class PostsViewController: UIViewController {

    // MARK: - Properties

    var posts: [Post] = []
    var row: Int?
    var offset = 0
    var reachedEndOfItems = false

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animatedLogoView: UIView!
    @IBOutlet weak var animatedLogo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        setupSubviews()
    }

    // MARK: - Methods

    private func setupSubviews() {
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        animatedLogo.heartbeatAnimation()
        animatedLogo.startAnimating()
    }

    private func fetchPosts() {
        Networking.shared.getAllPosts(offset: offset) { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self.animatedLogoView.alpha = 0
                    self.animatedLogo.stopAnimating()
                }
            }
        } onError: { errorMessage in
            print(errorMessage ?? "")
        }
    }
    
    private func loadMore() {
        guard !self.reachedEndOfItems else {
            return
        }

        DispatchQueue.global(qos: .background).async {
            var thisBatchOfItems: [Post]?
    

            Networking.shared.getAllPosts(offset: self.offset, onSuccess: { posts in
                thisBatchOfItems = posts
                DispatchQueue.main.async {

                    if let newItems = thisBatchOfItems {
                        self.posts.append(contentsOf: newItems)
                        self.tableView.reloadData()
                        if newItems.count < 25 {
                            self.reachedEndOfItems = true
                        }
                        self.offset += 25
                    }
                }
            }) { errorMessage in
                print("query failed")
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
            if let detailVC = segue.destination as? PostDetailViewController {
                detailVC.post = posts[row!]
            }
        }
    }
}

extension PostsViewController: PostTVCellDelegate {
    func buttonTapped(int: Int) {
        row = int
        self.performSegue(withIdentifier: "postDetailSegue", sender: self)
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

        let post = posts[indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let someDateTime = dateFormatter.date(from: post.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            let date = formatter.string(from: someDateTime)
            cell.dateLabel.text = date
        } else {
            cell.dateLabel.text = ""
        }
        let string = post.title.rendered.replacingOccurrences(of: "&#8211;", with: "-", options: .literal, range: nil)
        let replaced = string.replacingOccurrences(of: "&#038;", with: "&", options: .literal, range: nil)
        cell.titleLabel.text = replaced.capitalized
        let url = URL(string: post.jetpack_featured_media_url ?? "")
        cell.postImageView.kf.setImage(with: url)
        cell.postTVCellDelegate = self
        cell.indexPath = indexPath

        if indexPath.row == self.posts.count - 1 {
            self.loadMore()
        }

        return cell
    }
}

extension PostsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //ReloadViews
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //Search!!!!!
    }
}
