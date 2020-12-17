//
//  RankingsViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 12/17/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController {

    // MARK: - Properties
    
    var networking = Networking()
    
    // MARK: - Outlets
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.fetchRankings()
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

}
