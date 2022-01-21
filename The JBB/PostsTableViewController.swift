//
//  PostsTableViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit

class PostsTableViewController: UITableViewController {

    // MARK: - Properties
    
    // MARK: - Outlets
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
