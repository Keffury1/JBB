//
//  TeamsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit
import MapKit

class TeamsViewController: UIViewController, TableViewCellDelegate {
    
    // MARK: - Properties
    
    var players: [Player] = [] {
        didSet {
            self.teams = Networking.shared.sortPlayersByTeam(from: self.players)
        }
    }
    var teams: [[Player]] = []
    var divisionOne: [[Player]] = []
    var divisionTwo: [[Player]] = []
    var divisionThree: [[Player]] = []
    var cCCAA: [[Player]] = []
    var searchResults: [[Player]]?
    var selectedIndex = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamsMapView: MKMapView!
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var teamsSearchBar: UISearchBar!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - Methods
    
    func buttonPressed(index: Int) {
        
        var sender: [Player]?
        
        switch selectedIndex {
        case 0:
            sender = divisionOne[index]
        case 1:
            sender = divisionTwo[index]
        case 2:
            sender = divisionThree[index]
        case 3:
            sender = cCCAA[index]
        default:
            return
        }
        
        self.performSegue(withIdentifier: "rosterSegue", sender:  sender)
    }
    
    func setupSubviews() {
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        teamsMapView.delegate = self
        teamsSearchBar.delegate = self
        teamsSearchBar.backgroundImage = UIImage()
        
        self.players = Networking.shared.playerList ?? []
        for team in self.teams {
            if team.first?.division == "1" {
                self.divisionOne.append(team)
            }
        }
        self.teamsTableView.reloadData()
    }
    
    func addAnnotation(_ player: Player) {
        let all = teamsMapView.annotations
        teamsMapView.removeAnnotations(all)
        let annotation = MKPointAnnotation()
        annotation.title = player.school
        let lat = CLLocationDegrees(player.lat)
        let lon = CLLocationDegrees(player.lon)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        teamsMapView.addAnnotation(annotation)
    }

    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            for team in teams {
                if team.first?.division == "1" {
                    divisionOne.append(team)
                }
            }
        case 1:
            for team in teams {
                if team.first?.division == "2" {
                    divisionTwo.append(team)
                }
            }
        case 2:
            for team in teams {
                if team.first?.division == "3" {
                    divisionThree.append(team)
                }
            }
        case 3:
            for team in teams {
                if team.first?.division == "CCCAA" {
                    cCCAA.append(team)
                }
            }
        default:
            return
        }
        teamsTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rosterSegue" {
            if let detailVC = segue.destination as? TeamDetailViewController {
                detailVC.team = sender as? [Player]
            }
        }
    }
}

extension TeamsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults?.count != nil {
            return searchResults!.count
        } else {
            switch selectedIndex {
            case 0:
                return divisionOne.count
            case 1:
                return divisionTwo.count
            case 2:
                return divisionThree.count
            case 3:
                return cCCAA.count
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.index = indexPath.row
        
        var team: [Player]?
        
        if searchResults?.count != nil {
            team = searchResults![indexPath.row]
        } else {
            switch selectedIndex {
            case 0:
                team = divisionOne[indexPath.row]
            case 1:
                team = divisionTwo[indexPath.row]
            case 2:
                team = divisionThree[indexPath.row]
            case 3:
                team = cCCAA[indexPath.row]
            default:
                return UITableViewCell()
            }
        }
        
        guard let teamCell = team else { return UITableViewCell() }
        
        cell.teamNameLabel.text = teamCell.first?.school
        
        Networking.shared.fetchImage(at: teamCell.first?.image) { (data) in
            
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedIndex {
        case 0:
            let team = divisionOne[indexPath.row]
            if let player = team.first {
                addAnnotation(player)
            }
        case 1:
            let team = divisionOne[indexPath.row]
            if let player = team.first {
                addAnnotation(player)
            }
        case 2:
            let team = divisionOne[indexPath.row]
            if let player = team.first {
                addAnnotation(player)
            }
        case 3:
            let team = divisionOne[indexPath.row]
            if let player = team.first {
                addAnnotation(player)
            }
        default:
            return
        }
    }
}

extension TeamsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.canShowCallout = true
        annotationView.pinTintColor = UIColor.init(named: "Indigo")
        
        return annotationView
    }
}

extension TeamsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
        var results: [[Player]]?
        
        switch selectedIndex {
        case 0:
            results = divisionOne.filter({ (team) -> Bool in
                team.contains(where: { $0.school == searchTerm })
            })
        case 1:
            results = divisionTwo.filter({ (team) -> Bool in
                team.contains(where: { $0.school == searchTerm })
            })
        case 2:
            results = divisionThree.filter({ (team) -> Bool in
                team.contains(where: { $0.school == searchTerm })
            })
        case 3:
            results = cCCAA.filter({ (team) -> Bool in
                team.contains(where: { $0.school == searchTerm })
            })
        default:
            return
        }
        if let result = results {
            self.searchResults = result
            self.teamsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = nil
        teamsTableView.reloadData()
    }
}
