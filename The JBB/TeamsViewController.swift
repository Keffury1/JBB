//
//  TeamsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit
import MapKit

class TeamsViewController: UIViewController {

    // MARK: - Properties
    
    var players: [Player] = []
    var teams: [[Player]] = []
    var divisionOne: [[Player]] = []
    var divisionTwo: [[Player]] = []
    var divisionThree: [[Player]] = []
    var cCCAA: [[Player]] = []
    var selectedIndex = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var teamsMapView: MKMapView!
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var teamsSearchBar: UISearchBar!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
    // MARK: - Views
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Networking.shared.fetchTeams(completion: { (result) in
            DispatchQueue.main.async {
                do {
                    let result = try result.get()
                    self.players = result
                    self.teams = Networking.shared.sortPlayersByTeam(from: self.players)
                    for team in self.teams {
                        if team.first?.division == "1" {
                            self.divisionOne.append(team)
                        }
                    }
                    self.teamsTableView.reloadData()
                } catch {
                    print("Error getting rankings: \(error)")
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    // MARK: - Methods
    
    func setupSubviews() {
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        teamsMapView.delegate = self
        teamsSearchBar.delegate = self
        teamsSearchBar.backgroundImage = UIImage()
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
            let division = "1"
            for team in teams {
                if team.first?.division == division {
                    divisionOne.append(team)
                }
            }
        case 1:
            let division = "2"
            for team in teams {
                if team.first?.division == division {
                    divisionTwo.append(team)
                }
            }
        case 2:
            let division = "3"
            for team in teams {
                if team.first?.division == division {
                    divisionThree.append(team)
                }
            }
        case 3:
            let division = "CCCAA"
            for team in teams {
                if team.first?.division == division {
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
            if let detailVC = segue.destination as? TeamDetailViewController,
               let indexPath = teamsTableView.indexPathForSelectedRow {
                detailVC.team = teams[indexPath.row]
            }
        }
    }
}

extension TeamsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell else { return UITableViewCell() }
        
        var team: [Player]?
        
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
        
    }
}
