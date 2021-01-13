//
//  TeamsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit
import MapKit
import UIImageColors
import GoogleMobileAds

class TeamsViewController: UIViewController, TableViewCellDelegate, GADBannerViewDelegate {
    
    // MARK: - Properties
    
    var bannerAd = "ca-app-pub-9585815002804979/7202756884"
    var testBannerAd = "ca-app-pub-3940256099942544/2934735716"
    var divisionOne: [[Player]] = []
    var divisionTwo: [[Player]] = []
    var divisionThree: [[Player]] = []
    var cCCAA: [[Player]] = []
    var searchResults: [[Player]]?
    var selectedIndex = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var teamsMapView: MKMapView!
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var teamsSearchBar: UISearchBar!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        filterTeams()
        bannerView.isHidden = true
        setupAds()
    }
    
    // MARK: - Methods
    
    func setupAds() {
        bannerView.delegate = self
        bannerView.adUnitID = testBannerAd
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    
    func buttonPressed(index: Int) {
        
        var sender: [Player]?
        
        if searchResults != nil {
            sender = searchResults![index]
        } else {
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
        }
        
        self.performSegue(withIdentifier: "rosterSegue", sender:  sender)
    }
    
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
    
    func filterTeams() {
        if let teams = Networking.shared.playerList {
            teams.forEach { (team) in
                switch team.first?.division {
                case "1":
                    divisionOne.append(team)
                case "2":
                    divisionTwo.append(team)
                case "3":
                    divisionThree.append(team)
                case "CCCAA":
                    cCCAA.append(team)
                default:
                    return
                }
            }
        }
        teamsTableView.reloadData()
    }
    
    func searchForTeams(with searchTerm: String) {
        var results: [[Player]]?
        
        switch selectedIndex {
        case 0:
            results = divisionOne.filter({ (team) -> Bool in
                team.contains(where: { $0.school.contains(searchTerm) })
            })
        case 1:
            results = divisionTwo.filter({ (team) -> Bool in
                team.contains(where: { $0.school.contains(searchTerm) })
            })
        case 2:
            results = divisionThree.filter({ (team) -> Bool in
                team.contains(where: { $0.school.contains(searchTerm) })
            })
        case 3:
            results = cCCAA.filter({ (team) -> Bool in
                team.contains(where: { $0.school.contains(searchTerm) })
            })
        default:
            results = nil
        }
        if results?.isEmpty == true {
            self.searchResults = nil
        } else {
            if let result = results {
                self.searchResults = result
            }
        }
        
        teamsTableView.reloadData()
    }

    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        if teamsSearchBar.text != nil {
            searchForTeams(with: teamsSearchBar.text!)
        } else {
            teamsTableView.reloadData()
        }
        teamsSearchBar.endEditing(true)
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
        if searchResults != nil {
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
        
        if searchResults != nil {
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
        let lat = Double(teamCell.first!.lat)
        let lon = Double(teamCell.first!.lon)
        cell.latLonLabel.text = "\(String(format: "%.2f", ceil(lat!*100)/100)) | \(String(format: "%.2f", ceil(lon!*100)/100))"
        cell.regionLabel.text = teamCell.first?.region
        
        Networking.shared.fetchImage(at: teamCell.first?.image) { (data) in
            
            if let data = data {
                DispatchQueue.main.async {
                    cell.teamImageView.image = UIImage(data: data)
                    cell.teamImageView.image?.getColors { colors in
                        cell.rosterButton.tintColor = colors?.primary
                        cell.teamImageView.layer.borderColor = colors?.primary.cgColor
                    }
                }
            } else {
                print("Error fetching leader image")
            }
        }
        
        cell.teamImageView.layer.cornerRadius = cell.teamImageView.frame.size.width / 2
        cell.teamImageView.clipsToBounds = true
        cell.teamImageView.layer.borderWidth = 1.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchResults != nil {
            let team = searchResults![indexPath.row]
            if let player = team.first {
                addAnnotation(player)
            }
        } else {
            switch selectedIndex {
            case 0:
                let team = divisionOne[indexPath.row]
                if let player = team.first {
                    addAnnotation(player)
                }
            case 1:
                let team = divisionTwo[indexPath.row]
                if let player = team.first {
                    addAnnotation(player)
                }
            case 2:
                let team = divisionThree[indexPath.row]
                if let player = team.first {
                    addAnnotation(player)
                }
            case 3:
                let team = cCCAA[indexPath.row]
                if let player = team.first {
                    addAnnotation(player)
                }
            default:
                return
            }
        }
    }
}

extension TeamsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.canShowCallout = true
        annotationView.pinTintColor = UIColor.black
        
        return annotationView
    }
}

extension TeamsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchForTeams(with: searchTerm)
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = nil
        searchBar.endEditing(true)
        teamsTableView.reloadData()
    }
}
