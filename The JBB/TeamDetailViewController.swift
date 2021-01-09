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
    
    @IBOutlet weak var teamImageView: UIImageView!
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
        cell.heightWeightLabel.text = "\(player.height)/\(player.weight)"
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
        
        return cell
    }
    
    
}
