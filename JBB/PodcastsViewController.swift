//
//  PodcastsViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 8/31/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class PodcastsViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Outlets
    
    @IBOutlet weak var subscribeButton: UIButton!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeButton.addShadow()
        subscribeButton.addRounding()
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
