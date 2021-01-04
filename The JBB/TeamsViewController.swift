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
                    self.addAnnotations()
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
    
    func addAnnotations() {
        let all = teamsMapView.annotations
        teamsMapView.removeAnnotations(all)
        for team in teams {
            if let player = team.first {
                let annotation = MKPointAnnotation()
                annotation.title = player.school
                let lat = CLLocationDegrees(player.lat)
                let lon = CLLocationDegrees(player.lon)
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                teamsMapView.addAnnotation(annotation)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: Any) {
        // Handle Multiple Divisions
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
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)
        
        let team = teams[indexPath.row]
        
        guard let player = team.first else { return UITableViewCell() }
        
        cell.textLabel?.text = player.school
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
    
}
