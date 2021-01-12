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
    
    var team: [Player]?
    var searchResult: [Player]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView! {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var rosterTableView: UITableView!
    
    // MARK: - Views
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupSubviews()
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        rosterTableView.dataSource = self
        if let team = team {
            teamNameLabel.text = team.first?.school
            Networking.shared.fetchImage(at: team.first?.image, completion: { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.teamImageView.image = UIImage(data: data)
                        self.updateViews()
                    }
                } else {
                    print("Error fetching leader image")
                }
            })
        }
    }
    
    func updateViews() {
        rosterTableView.reloadData()
        teamImageView.image?.getColors { colors in
            self.view.backgroundColor = colors?.background
            self.teamNameLabel.textColor = colors?.primary
            self.teamImageView.layer.borderColor = colors?.primary.cgColor
        }
        teamImageView.layer.cornerRadius = teamImageView.frame.size.width / 2
        teamImageView.clipsToBounds = true
        teamImageView.layer.borderWidth = 2.0
    }
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension TeamDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerTableViewCell else { return UITableViewCell() }
        
        guard let team = team else { return UITableViewCell() }
        
        let player = team[indexPath.row]
        
        cell.numberLabel.text = player.num
        cell.nameLabel.text = player.name
        cell.hometownLabel.text = player.hometown
        cell.positionLabel.text = player.pos
        cell.batThrowLabel.text = player.batThrow
        cell.heightWeightLabel.text = "\(player.height) \(player.weight)"
        switch Int(player.year) {
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
        
        teamImageView.image?.getColors { colors in
            cell.yearLabel.textColor = colors?.secondary
            cell.backgroundColor = colors?.background
            cell.heightWeightLabel.textColor = colors?.secondary
            cell.batThrowLabel.textColor = colors?.secondary
            cell.positionLabel.textColor = colors?.secondary
            cell.numberLabel.textColor = colors?.secondary
            cell.nameLabel.textColor = colors?.primary
            cell.hometownLabel.textColor = colors?.secondary
        }
        return cell
    }
}
