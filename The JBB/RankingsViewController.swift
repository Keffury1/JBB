//
//  RankingsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit

class RankingsViewController: UIViewController {

    // MARK: - Properties
    
    var division1: [[Player]] = []
    var division2: [[Player]] = []
    var division3: [[Player]] = []
    var selectedSegmentIndex = 0
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+")
    
    // MARK: - Outlets
    
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var rankingsTableView: UITableView!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
    // MARK: - Views
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupSubviews()
        if Networking.shared.started == true {
            startAnimation()
        } else {
            stopAnimation()
        }
        Networking.shared.rankingsDelegate = self
    }
    
    // MARK: - Methods
    
    private func setupSubviews() {
        rankingsTableView.dataSource = self
        rankingsTableView.delegate = self
    }
    
    private func startAnimation() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [.repeat, .autoreverse], animations: {
            self.logoImageView.transform = .identity
        }, completion: nil)
    }
    
    private func stopAnimation() {
        UIView.animate(withDuration: 1.0) {
            self.logoView.alpha = 0
        }
        self.logoImageView.stopAnimating()
        super.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        rankingsTableView.setContentOffset(.zero, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.rankingsTableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoster" {
            if let detailVC = segue.destination as? TeamDetailViewController, let indexPath = rankingsTableView.indexPathForSelectedRow {
                switch selectedSegmentIndex {
                case 0:
                    detailVC.team = division1[indexPath.row]
                case 1:
                    detailVC.team = division2[indexPath.row]
                case 2:
                    detailVC.team = division3[indexPath.row]
                default:
                    return
                }
            }
        }
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
        
        var team: [Player]?
        
        switch selectedSegmentIndex {
        case 0:
            team = division1[indexPath.row]
        case 1:
            team = division2[indexPath.row]
        case 2:
            team = division3[indexPath.row]
        default:
            return UITableViewCell()
        }
        
        guard let teamCell = team, let player = teamCell.first else { return UITableViewCell() }
        
        cell.teamNameLabel.text = player.school
        if player.rank == "1" {
            cell.rankLabel.text = "👑"
        } else {
            cell.rankLabel.text = player.rank
        }
        cell.recordLabel.text = player.record
        cell.changeLabel.text = player.change
        
        if player.change.rangeOfCharacter(from: characterset.inverted) != nil {
            if player.change == "-" {
                cell.changeLabel.textColor = .black
            } else {
                cell.changeLabel.textColor = .systemRed
            }
        } else {
            cell.changeLabel.textColor = .systemGreen
        }
        
        Networking.shared.fetchImage(at: player.image) { (data) in
            
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
        cell.teamImageView.layer.borderColor = UIColor.black.cgColor
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
                division1.append(team)
            case "2":
                division2.append(team)
            case "3":
                division3.append(team)
            default:
                return
            }
        }
        
        division1.sort { (team1, team2) -> Bool in
            Int((team1.first?.rank)!)! < Int((team2.first?.rank)!)!
        }
        division2.sort { (team1, team2) -> Bool in
            Int((team1.first?.rank)!)! < Int((team2.first?.rank)!)!
        }
        division3.sort { (team1, team2) -> Bool in
            Int((team1.first?.rank)!)! < Int((team2.first?.rank)!)!
        }
        
        DispatchQueue.main.async {
            self.rankingsTableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopAnimation()
        }
    }
}
