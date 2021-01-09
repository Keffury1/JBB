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
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var secondaryTextColor: UIColor?
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamImageView: UIImageView! {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var rosterTableView: UITableView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        rosterTableView.dataSource = self
        if let team = team {
            Networking.shared.fetchImage(at: team.first?.image, completion: { (data) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.teamImageView.image = UIImage(data: data)
                    }
                } else {
                    print("Error fetching leader image")
                }
            })
        }
    }
    
    func updateViews() {
        teamImageView.image?.getColors { colors in
            self.backgroundColor = colors?.background
            self.view.backgroundColor = self.backgroundColor
            self.textColor = colors?.primary
            self.secondaryTextColor = colors?.secondary
        }
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
        cell.numberLabel.textColor = secondaryTextColor
        cell.nameLabel.text = player.name
        cell.nameLabel.textColor = textColor
        cell.hometownLabel.text = player.hometown
        cell.hometownLabel.textColor = secondaryTextColor
        cell.positionLabel.text = player.pos
        cell.positionLabel.textColor = secondaryTextColor
        cell.batThrowLabel.text = player.batThrow
        cell.batThrowLabel.textColor = secondaryTextColor
        cell.heightWeightLabel.text = "\(player.height)/\(player.weight)"
        cell.heightWeightLabel.textColor = secondaryTextColor
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
        cell.yearLabel.textColor = secondaryTextColor
        
        cell.backgroundColor = backgroundColor
        return cell
    }
}
