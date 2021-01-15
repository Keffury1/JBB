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
    private var searchResults: [[Player]]?
    var selectedSegmentIndex = 0
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+")
    private var searching: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var noRankResultsView: UIView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var rankingsSearchBar: UISearchBar!
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
        rankingsSearchBar.delegate = self
        rankingsSearchBar.tintColor = .black
        rankingsSearchBar.placeholder = "Search Leaders"
        rankingsSearchBar.backgroundImage = UIImage()
    }
    
    private func startAnimation() {
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [.repeat, .autoreverse], animations: {
            self.logoImageView.transform = .identity
        }, completion: nil)
    }
    
    private func stopAnimation() {
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.logoView.alpha = 0
            self.tabBarController?.tabBar.alpha = 1
        }
        self.logoImageView.stopAnimating()
    }
    
    private func searchForTeams(with searchTerm: String) {
        noRankResultsView.alpha = 0
        self.searching = true
        var results: [[Player]]?
        
        if searchTerm == "" {
            searchResults = nil
            self.searching = false
            rankingsTableView.reloadData()
            return
        } else {
            switch selectedSegmentIndex {
            case 0:
                results = division1.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.contains(searchTerm) })
                })
            case 1:
                results = division2.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.contains(searchTerm) })
                })
            case 2:
                results = division3.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.contains(searchTerm) })
                })
            default:
                results = nil
            }
            if let result = results {
                if result.count == 0 {
                    noRankResultsView.alpha = 1
                    self.searchResults = nil
                } else {
                    self.searchResults = result
                }
            }
        }
        
        rankingsTableView.reloadData()
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
        if searchResults != nil {
            return searchResults!.count
        } else {
            if searching {
                return 0
            } else {
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? RankingTableViewCell else { return UITableViewCell() }
        
        var team: [Player]?
        
        if searchResults != nil {
            team = searchResults![indexPath.row]
        } else {
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
        
        let token = ImageLoader.shared.fetchImage(at: player.image) { (result) in
            
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    cell.teamImageView.image = image
                }
            } catch {
                print(error)
            }
        }
        
        cell.onReuse = {
            if let token = token {
                ImageLoader.shared.cancelLoad(token)
            }
        }
        
        cell.teamImageView.layer.cornerRadius = cell.teamImageView.frame.size.width / 2
        cell.teamImageView.clipsToBounds = true
        cell.teamImageView.layer.borderColor = UIColor.black.cgColor
        cell.teamImageView.layer.borderWidth = 0.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension RankingsViewController: RankingsFilledDelegate {
    func teamsWereFilled() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopAnimation()
        }
    }
    
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
    }
}

extension RankingsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchForTeams(with: searchTerm)
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        noRankResultsView.alpha = 0
    }
}
