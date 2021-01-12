//
//  RankingsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit

class RankingsViewController: UIViewController {

    // MARK: - Properties
    
    var division1: [Ranking] = []
    var division2: [Ranking] = []
    var division3: [Ranking] = []
    var CCCAA: [Ranking] = []
    var selectedSegmentIndex = 0
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+")
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var rankingsTableView: UITableView!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
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
        rankingsTableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        rankingsTableView.reloadData()
    }
}

extension RankingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
        
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
            return UITableViewCell()
        }
        
        guard let rank = cellRank, let change = rank.Change else { return UITableViewCell() }
        
        cell.teamNameLabel.text = rank.Team
        cell.rankLabel.text = "# \(rank.Rank)"
        cell.recordLabel.text = rank.Record
        
        if change.rangeOfCharacter(from: characterset.inverted) != nil {
            cell.changeLabel.textColor = .systemRed
        } else {
            cell.changeLabel.textColor = .systemGreen
        }
        
        Networking.shared.fetchImage(at: rank.Image) { (data) in
            
            if let data = data {
                DispatchQueue.main.async {
                    cell.teamImageView.image = UIImage(data: data)
                }
            } else {
                print("Error fetching leader image")
            }
        }
        
        cell.teamImageView.layer.cornerRadius = cell.teamImageView.frame.size.width / 2
        cell.teamImageView.clipsToBounds = true
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        
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
        
        rankingsTableView.reloadData()
    }
}
