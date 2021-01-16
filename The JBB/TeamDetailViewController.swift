//
//  TeamDetailViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit
import UIImageColors

class TeamDetailViewController: UIViewController {

    // MARK: - Properties
    
    var team: [Player]? {
        didSet {
            team?.sort(by: { (player1, player2) -> Bool in
                let a:Int? = Int(player1.num) // firstText is UITextField
                let b:Int? = Int(player2.num)
                guard let num1 = a, let num2 = b else { return false }
                return num1 < num2
            })
        }
    }
    var primary: UIColor?
    var secondary: UIColor?
    var background: UIColor? {
        didSet {
            rosterTableView.reloadData()
        }
    }
    private var searchResults: [Player]?
    private var searching: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var noPlayersView: UIView!
    @IBOutlet weak var noPlayersLabel: UILabel!
    @IBOutlet weak var noPlayersImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var backgroundTeamImageView: UIView!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playerSearchBar: UISearchBar!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.stopAnimation()
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        playerSearchBar.delegate = self
        playerSearchBar.placeholder = "Search Athletes"
        playerSearchBar.backgroundImage = UIImage()
        rosterTableView.dataSource = self
        if let team = team {
            teamNameLabel.text = team.first?.school
            if team.first!.record != "" {
                recordLabel.text = "(\(team.first!.record))"
            } else {
                recordLabel.text = ""
            }
            let _ = ImageLoader.shared.fetchImage(at: team.first?.image) { (result) in
                do {
                    let image = try result.get()
                    DispatchQueue.main.async {
                        self.teamImageView.image = image
                        self.rosterTableView.reloadData()
                        self.teamImageView.image?.getColors { colors in
                            self.rosterTableView.backgroundColor = colors?.background
                            self.primary = colors?.primary
                            self.secondary = colors?.secondary
                            self.background = colors?.background
                            self.view.backgroundColor = colors?.background
                            self.teamNameLabel.textColor = colors?.primary
                            self.teamImageView.layer.borderColor = colors?.primary.cgColor
                            self.recordLabel.textColor = colors?.primary
                            let textFieldInsideSearchBar = self.playerSearchBar.value(forKey: "searchField") as? UITextField
                            textFieldInsideSearchBar?.textColor = colors?.primary
                            self.playerSearchBar.tintColor = colors?.primary
                            self.noPlayersView.backgroundColor = colors?.background
                            self.noPlayersImageView.tintColor = colors?.primary
                            self.noPlayersLabel.textColor = colors?.primary
                        }
                        
                        self.teamImageView.layer.cornerRadius = self.teamImageView.frame.size.width / 2
                        self.teamImageView.clipsToBounds = true
                        self.teamImageView.layer.borderWidth = 2.0
                        self.backgroundTeamImageView.layer.cornerRadius = self.teamImageView.frame.size.width / 2
                        self.backgroundTeamImageView.clipsToBounds = true
                        self.backgroundTeamImageView.layer.borderWidth = 2.0
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func searchForTeams(with searchTerm: String) {
        guard let team = team else { return }
        
        noPlayersView.alpha = 0
        searching = true
        var results: [Player]?
        
        if searchTerm == "" {
            searchResults = nil
            self.searching = false
            rosterTableView.reloadData()
            return
        } else {
            results = team.filter { (player) -> Bool in
                player.name.lowercased().contains(searchTerm.lowercased())
            }
        }
        
        if let result = results {
            if result.count == 0 {
                self.searchResults = nil
                noPlayersView.alpha = 1
            } else {
                self.searchResults = result
            }
        }
        rosterTableView.reloadData()
    }
    
    private func startAnimation() {
        logoImageView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001)
        UIView.animate(withDuration: 3.0, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            self.logoImageView.transform = .identity
        }, completion: nil)
    }
    
    private func stopAnimation() {
        logoImageView.stopAnimating()
        UIView.animate(withDuration: 1.0) {
            self.logoView.alpha = 0
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension TeamDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults != nil {
            return searchResults!.count
        } else {
            return team?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerTableViewCell else { return UITableViewCell() }
        
        guard let team = team else { return UITableViewCell() }
        
        var player: Player?
        
        if searchResults != nil {
            player = searchResults![indexPath.row]
        } else {
            player = team[indexPath.row]
        }
        
        guard let athlete = player else { return UITableViewCell() }
        
        cell.numberLabel.text = athlete.num
        cell.nameLabel.text = athlete.name
        cell.nameLabel.text = cell.nameLabel.text?.capitalized
        cell.hometownLabel.text = athlete.hometown
        cell.hometownLabel.text = cell.hometownLabel.text?.capitalized
        if athlete.hometown == "" {
            cell.hometownLabel.isHidden = true
        } else {
            cell.hometownLabel.isHidden = false
        }
        cell.positionLabel.text = athlete.pos
        cell.batThrowLabel.text = athlete.batThrow
        cell.heightWeightLabel.text = "\(athlete.height) \(athlete.weight)"
        
        switch Int(athlete.year) {
        case 1:
            cell.yearLabel.text = "Fr"
        case 2:
            cell.yearLabel.text = "So"
        case 3:
            cell.yearLabel.text = "Jr"
        case 4:
            cell.yearLabel.text = "Sr"
        default:
            cell.yearLabel.text = ""
        }
        
        cell.yearLabel.textColor = secondary
        cell.backgroundColor = background
        cell.heightWeightLabel.textColor = secondary
        cell.batThrowLabel.textColor = secondary
        cell.positionLabel.textColor = secondary
        cell.numberLabel.textColor = secondary
        cell.nameLabel.textColor = primary
        cell.hometownLabel.textColor = secondary
        
        return cell
    }
}

extension TeamDetailViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchForTeams(with: searchTerm)
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        noPlayersView.alpha = 0
    }
}
