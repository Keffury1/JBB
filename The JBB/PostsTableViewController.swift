//
//  PostsTableViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit

class PostsTableViewController: UITableViewController {

    // MARK: - Properties
    
    var posts: [Post] = []
    
    // MARK: - Outlets
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
    }
    
    // MARK: - Methods
    
    private func fetchPosts() {
        Networking.shared.getAllPosts { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } onError: { errorMessage in
            print(errorMessage ?? "")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

        let post = posts[indexPath.row]

        cell.titleLabel.text = post.title.rendered.capitalized

        return cell
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
