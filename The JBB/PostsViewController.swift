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
    var searchedPosts: [Post] = []
    var categories: [Category] = []
    var row: Int?
    var offset = 0
    var reachedEndOfItems = false
    var isSearching = false

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animatedLogoView: UIView!
    @IBOutlet weak var animatedLogo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topButton: UIButton!
    
    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
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
        topButton.setTitle("", for: .normal)
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
    
    private func fetchCategories() {
        Networking.shared.getAllCategories { categories in
            self.categories = categories
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
    
    private func translateCategories(_ post_categories: [Int]) -> [String] {
        var strings: [String] = []

        for post_category in post_categories {
            strings.append(categories.first(where: { $0.id == post_category })?.name ?? "")
        }

        return strings
    }
    
    // MARK: - Actions
    
    @IBAction func topButtonTapped(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
            if let detailVC = segue.destination as? PostDetailViewController {
                detailVC.post = posts[row!]
                detailVC.categories = translateCategories(posts[row!].categories ?? [])
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
        if isSearching == true {
            return searchedPosts.count
        } else {
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

        var post: Post?
        
        if isSearching == true {
            post = searchedPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }

        if let post = post {
            cell.postCategories = translateCategories(post.categories ?? [])
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
            cell.titleLabel.text = post.title.rendered.html2String.capitalized
            let url = URL(string: post.jetpack_featured_media_url ?? "")
            cell.postImageView.kf.setImage(with: url)
            cell.postTVCellDelegate = self
            cell.indexPath = indexPath

            if indexPath.row == self.posts.count - 1 {
                self.loadMore()
            }
        }

        return cell
    }
}

extension PostsViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            isSearching = false
        } else {
            isSearching = true
            searchedPosts = posts.filter { $0.title.rendered.html2String.contains(searchBar.text ?? "")}
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
