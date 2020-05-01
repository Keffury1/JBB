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
    
    //MARK: - Outlets
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    //MARK: - Methods
    
    //MARK: - Actions
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
