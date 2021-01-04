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
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playerSearchBar: UISearchBar!
    @IBOutlet weak var rosterCollectionView: UICollectionView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        playerSearchBar.delegate = self
        playerSearchBar.backgroundImage = UIImage()
        rosterCollectionView.dataSource = self
        rosterCollectionView.delegate = self
        teamNameLabel.text = team?.first?.school
    }
    
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
            
            cell.numberLabel.text = "#\(player.num)"
            cell.positionLabel.text = player.pos
            cell.batThrowLabel.text = player.batThrow
            cell.nameLabel.text = player.name
            cell.heightLabel.text = player.height
            cell.weightLabel.text = player.weight
            cell.hometownLabel.text = player.hometown
            
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.shadowView.layer.shadowColor = UIColor.lightGray.cgColor
            cell.shadowView.layer.shadowOffset = CGSize(width:0.0, height: 2.0)
            cell.shadowView.layer.shadowRadius = 2.0
            cell.shadowView.layer.shadowOpacity = 1.0
            cell.shadowView.layer.cornerRadius = 10.0
            cell.shadowView.layer.masksToBounds = false
        }
        return cell
    }
}

extension TeamDetailViewController: UISearchBarDelegate {
    
}
