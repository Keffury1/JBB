//
//  Top100ViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 12/1/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class Top100ViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var top100TableView: UITableView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        top100TableView.dataSource = self
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
}

extension Top100ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "prospectCell", for: indexPath) as? ProspectTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
