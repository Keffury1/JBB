//
//  RankingsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit

class RankingsViewController: UIViewController {

    // MARK: - Properties
    
    var division1: [Player] = []
    var division2: [Player] = []
    var division3: [Player] = []
    var selectedSegmentIndex = 0
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+")
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var rankingsTableView: UITableView!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        startAnimation()
        Networking.shared.rankingsDelegate = self
    }
    
    // MARK: - Methods
    
    private func setupSubviews() {
        rankingsTableView.dataSource = self
        rankingsTableView.delegate = self
    }
    
    private func startAnimation() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            self.logoImageView.transform = .identity
        }, completion: nil)
    }
    
    private func stopAnimation() {
        UIView.animate(withDuration: 1.0) {
            self.logoView.alpha = 0
        }
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        rankingsTableView.reloadData()
    }
}

extension RankingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedSegmentIndex {
        case 0:
            return division1.count
        case 1:
            return division2.count
        case 2:
            return division3.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
        
        var cellRank: Player?
        
        switch selectedSegmentIndex {
        case 0:
            cellRank = division1[indexPath.row]
        case 1:
            cellRank = division2[indexPath.row]
        case 2:
            cellRank = division3[indexPath.row]
        default:
            return UITableViewCell()
        }
        
        guard let rank = cellRank else { return UITableViewCell() }
        
        cell.teamNameLabel.text = rank.school
        if rank.rank == "1" {
            cell.rankLabel.text = "👑"
        } else {
            cell.rankLabel.text = rank.rank
        }
        cell.recordLabel.text = rank.record
        cell.changeLabel.text = rank.change
        
        if rank.change.rangeOfCharacter(from: characterset.inverted) != nil {
            if rank.change == "-" {
                cell.changeLabel.textColor = .black
            } else {
                cell.changeLabel.textColor = .systemRed
            }
        } else {
            cell.changeLabel.textColor = .systemGreen
        }
        
        Networking.shared.fetchImage(at: rank.image) { (data) in
            
            if let data = data {
                DispatchQueue.main.async {
                    cell.teamImageView.image = UIImage(data: data)
                    cell.teamImageView.image?.getColors { colors in
                        cell.teamImageView.layer.borderColor = colors?.primary.cgColor
                    }
                }
            } else {
                print("Error fetching leader image")
            }
        }
        
        cell.teamImageView.layer.cornerRadius = cell.teamImageView.frame.size.width / 2
        cell.teamImageView.clipsToBounds = true
        cell.teamImageView.layer.borderWidth = 1.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension RankingsViewController: RankingsFilledDelegate {
    func rankingsWereFilled(list: [[Player]]) {
        let rankings = list
        
        rankings.forEach { (team) in
            switch team.first?.division {
            case "1":
                division1.append(contentsOf: team)
            case "2":
                division2.append(contentsOf: team)
            case "3":
                division3.append(contentsOf: team)
            default:
                return
            }
        }
        
        rankingsTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopAnimation()
        }
    }
}
