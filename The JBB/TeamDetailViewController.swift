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
    var searchResult: [Player]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playerSearchBar: UISearchBar!
    @IBOutlet weak var rosterCollectionView: UICollectionView!
    @IBOutlet weak var bannerAdView: UIView!
    
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
        if searchResult?.count != nil {
            return searchResult!.count
        } else {
            return team.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCell", for: indexPath) as? PlayerCollectionViewCell else { return UICollectionViewCell() }
        
        var player: Player?
        
        if searchResult != nil {
            player = searchResult![indexPath.row]
        } else {
            if let team = team {
                player = team[indexPath.row]
            }
        }
        
        guard let athlete = player else { return UICollectionViewCell() }
        
        cell.numberLabel.text = "#\(athlete.num)"
        cell.positionLabel.text = athlete.pos
        cell.batThrowLabel.text = athlete.batThrow
        cell.nameLabel.text = athlete.name
        cell.heightLabel.text = athlete.height
        cell.weightLabel.text = athlete.weight
        cell.hometownLabel.text = athlete.hometown
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.shadowView.layer.shadowOffset = CGSize(width:0.0, height: 2.0)
        cell.shadowView.layer.shadowRadius = 2.0
        cell.shadowView.layer.shadowOpacity = 1.0
        cell.shadowView.layer.cornerRadius = 10.0
        cell.shadowView.layer.masksToBounds = false
        
        return cell
    }
}

extension TeamDetailViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchResult = searchBar.text else { return }
        
        var results: [Player]?
        
        results = team?.filter({ (player) -> Bool in
            player.name.lowercased().contains(searchResult.lowercased())
        })
        
        self.searchResult = results
        rosterCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchResult = nil
        rosterCollectionView.reloadData()
    }
}
