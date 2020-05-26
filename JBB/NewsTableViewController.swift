//
//  NewsTableViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 5/1/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {

    //MARK: - Properties
    
    var postController = PostController()
    var posts: [Post] = []
    
    //MARK: - Outlets
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableViews()
    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        
        let post = posts[indexPath.row]
        
        cell.postTitleLabel.text = post.title.rendered
        cell.textView.text = post.content.rendered
        
        return cell
    }
    
    //MARK: - Methods
    
    func setupTableViews() {
        postController.fetchPosts { (posts, error) in
            if let error = error {
                print("Error fetching posts for tableView: \(error)")
                return
            }
            
            guard let posts = posts else {
                return
            }
            
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
