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
        playerSearchBar.backgroundImage = UIImage()
        rosterCollectionView.dataSource = self
        rosterCollectionView.delegate = self
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension TeamDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let team = team else { return 1 }
        return team.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as? PlayerCollectionViewCell else { return UICollectionViewCell() }
        
        if let team = team {
            
            let player = team[indexPath.row]
            
            cell.numberLabel.text = player.num
            cell.positionLabel.text = player.pos
            cell.batThrowLabel.text = player.batThrow
            cell.nameLabel.text = player.name
            cell.heightLabel.text = player.height
            cell.weightLabel.text = player.weight
            cell.hometownLabel.text = player.hometown
            
        }
        return cell
    }
}

extension TeamDetailViewController: UISearchBarDelegate {
    
}
