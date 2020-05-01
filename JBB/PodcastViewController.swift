//
//  PodcastViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 5/1/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController, UITableViewDataSource {

    //MARK: - Properties
    
    //MARK: - Outlets
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var podcastTableView: UITableView!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        podcastTableView.dataSource = self
        setupSubviews()
    }
    
    //MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    //MARK: - Methods
    
    private func setupSubviews() {
        subscribeButton.layer.cornerRadius = 15.0
    }
    
    //MARK: - Actions
    @IBAction func subscribeButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
