//
//  RankingsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit

class RankingsViewController: UIViewController {

    // MARK: - Properties
    
    var leader: Ranking? {
        didSet {
            updateViews()
        }
    }
    var rankingList: [Ranking] = [] {
        didSet {
            self.rankings = sortTeamsByDivision()
        }
    }
    var rankings: [[Ranking]] = []
    var division1: [Ranking] = []
    var division2: [Ranking] = []
    var division3: [Ranking] = []
    var CCCAA: [Ranking] = []
    var selectedSegmentIndex = 0
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    
    // MARK: - Outlets
    
    @IBOutlet weak var rankingsCollectionView: UICollectionView!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var leaderNameLabel: UILabel!
    @IBOutlet weak var leaderRecordLabel: UILabel!
    @IBOutlet weak var leaderChangeLabel: UILabel!
    @IBOutlet weak var leaderImageView: UIImageView!
    
    // MARK: - Views
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Networking.shared.fetchRankings { (result) in
            DispatchQueue.main.async {
                do {
                    let result = try result.get()
                    self.rankingList = result
                    self.division1 = self.rankings[1]
                    self.leader = self.division1.removeFirst()
                    self.rankingsCollectionView.reloadData()
                } catch {
                    print("Error getting rankings: \(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rankingsCollectionView.dataSource = self
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        guard let leader = leader, let change = leader.Change else { return }
        leaderNameLabel.text = leader.Team
        leaderRecordLabel.text = leader.Record
        leaderChangeLabel.text = leader.Change
        leaderImageView.image = UIImage(named: "Logo")
        
        if change.rangeOfCharacter(from: characterset.inverted) != nil {
            leaderChangeLabel.textColor = .red
        } else {
            leaderChangeLabel.textColor = .green
        }
    }
    
    func sortTeamsByDivision() -> [[Ranking]] {
        var rankings: [[Ranking]] = [[]]
        
        var previous: String? = nil
        
        for team in rankingList {
            let first = team.Division
            
            if first != previous {
                rankings.append([])
                previous = first
            }
            rankings[rankings.endIndex - 1].append(team)
        }
        return rankings
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        switch selectedSegmentIndex {
        case 0:
            division1 = rankings[1]
            leader = division1.removeFirst()
        case 1:
            division2 = rankings[2]
            leader = division2.removeFirst()
        case 2:
            division3 = rankings[3]
            leader = division3.removeFirst()
        case 3:
            CCCAA = rankings[4]
            leader = CCCAA.removeFirst()
        default:
            return
        }
        rankingsCollectionView.reloadData()
    }
}

extension RankingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedSegmentIndex {
        case 0:
            return division1.count
        case 1:
            return division2.count
        case 2:
            return division3.count
        case 3:
            return CCCAA.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as? TeamCollectionViewCell else { return UICollectionViewCell() }
        
        var cellRank: Ranking?
        
        switch selectedSegmentIndex {
        case 0:
            cellRank = division1[indexPath.row]
        case 1:
            cellRank = division2[indexPath.row]
        case 2:
            cellRank = division3[indexPath.row]
        case 3:
            cellRank = CCCAA[indexPath.row]
        default:
            return UICollectionViewCell()
        }
        
        guard let rank = cellRank, let change = rank.Change else { return UICollectionViewCell() }
        
        cell.nameLabel.text = rank.Team
        cell.rankLabel.text = "# \(rank.Rank)"
        cell.recordLabel.text = rank.Record
        cell.changeLabel.text = change
        
        if change.rangeOfCharacter(from: characterset.inverted) != nil {
            cell.changeLabel.textColor = .red
        } else {
            cell.changeLabel.textColor = .green
        }
        cell.logoImageView.image = UIImage(named: "Logo")
        
        return cell
    }
}