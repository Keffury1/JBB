//
//  TeamDetailViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit

class TeamDetailViewController: UIViewController {

    // MARK: - Properties
    
    var team: [Player]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var playerSearchBar: UISearchBar!
    @IBOutlet weak var rosterCollectionView: UICollectionView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerSearchBar.delegate = self
        rosterCollectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension TeamDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let team = team else { return 1 }
        return team.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as? PlayerCollectionViewCell, let team = team else { return UICollectionViewCell() }
        
        let player = team[indexPath.row]
        
        
        
        return cell
    }
}

extension TeamDetailViewController: UISearchBarDelegate {
    
}
