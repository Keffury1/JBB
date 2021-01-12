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
    var division1: [Ranking] = []
    var division2: [Ranking] = []
    var division3: [Ranking] = []
    var CCCAA: [Ranking] = []
    var selectedSegmentIndex = 0
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+")
    
    // MARK: - Outlets
    
    @IBOutlet weak var rankingsCollectionView: UICollectionView!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var leaderNameLabel: UILabel!
    @IBOutlet weak var leaderRecordLabel: UILabel!
    @IBOutlet weak var leaderChangeLabel: UILabel!
    @IBOutlet weak var leaderImageView: UIImageView!
    @IBOutlet weak var leaderView: UIView!
    
    // MARK: - Views
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        Networking.shared.rankingsDelegate = self
    }
    
    // MARK: - Methods
    
    private func setupSubviews() {
        rankingsCollectionView.dataSource = self
        leaderView.addShadow()
        leaderImageView.addShadow()
        leaderView.layer.cornerRadius = 10.0
        leaderImageView.layer.cornerRadius = 10.0
    }
    
    private func updateViews() {
        guard let leader = leader, let change = leader.Change else { return }
        leaderNameLabel.text = leader.Team
        leaderRecordLabel.text = leader.Record
        if leader.Change == "-" {
            leaderChangeLabel.text = "👑"
        } else {
            leaderChangeLabel.text = leader.Change
        }
        
        Networking.shared.fetchImage(at: leader.Image) { (data) in
            
            if let data = data {
                DispatchQueue.main.async {
                    self.leaderImageView.image = UIImage(data: data)
                }
            } else {
                print("Error fetching leader image")
            }
        }
        
        if change.rangeOfCharacter(from: characterset.inverted) != nil {
            leaderChangeLabel.textColor = .red
        } else {
            leaderChangeLabel.textColor = .green
        }
        self.rankingsCollectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        switch selectedSegmentIndex {
        case 0:
            leader = division1.first
        case 1:
            leader = division2.first
        case 2:
            leader = division3.first
        case 3:
            leader = CCCAA.first
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
            cell.changeLabel.textColor = .systemRed
        } else {
            cell.changeLabel.textColor = .systemGreen
        }
        
        Networking.shared.fetchImage(at: rank.Image) { (data) in
            
            if let data = data {
                DispatchQueue.main.async {
                    cell.logoImageView.image = UIImage(data: data)
                }
            } else {
                print("Error fetching leader image")
            }
        }
        
        cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
        cell.logoImageView.clipsToBounds = true
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.shadowView.addShadow()
        cell.shadowView.layer.cornerRadius = 10
        
        
        return cell
    }
}

extension RankingsViewController: RankingsFilledDelegate {
    func rankingsWereFilled(list: [[Ranking]]) {
        let rankings = list
        
        division1 = rankings[1]
        division2 = rankings[2]
        division3 = rankings[3]
        CCCAA = rankings[4]
        
        switch selectedSegmentIndex {
        case 0:
            leader = division1.removeFirst()
        case 1:
            leader = division2.removeFirst()
        case 2:
            leader = division3.removeFirst()
        case 3:
            leader = CCCAA.removeFirst()
        default:
            return
        }
        rankingsCollectionView.reloadData()
    }
}
