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
    var primary: UIColor?
    var secondary: UIColor?
    var background: UIColor? {
        didSet {
            rosterTableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.stopAnimation()
        }
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        rosterTableView.dataSource = self
        if let team = team {
            teamNameLabel.text = team.first?.school
            if team.first!.record != "" {
                recordLabel.text = "(\(team.first!.record))"
            } else {
                recordLabel.text = ""
            }
            Networking.shared.fetchImage(at: team.first?.image, completion: { (data) in
                if let data = data {
                    DispatchQueue.main.sync {
                        self.teamImageView.image = UIImage(data: data)
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
                        }
                        self.teamImageView.layer.cornerRadius = self.teamImageView.frame.size.width / 2
                        self.teamImageView.clipsToBounds = true
                        self.teamImageView.layer.borderWidth = 2.0
                    }
                } else {
                    print("Error fetching leader image")
                }
            })
        }
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
