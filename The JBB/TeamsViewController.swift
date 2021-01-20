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
    var testAd = "ca-app-pub-3940256099942544/6300978111"
    var teams: [[Player]]? {
        didSet {
            if let teams = teams {
                teamsWereFilled(list: teams)
            }
        }
    }
    var divisionOne: [[Player]] = []
    var divisionTwo: [[Player]] = []
    var divisionThree: [[Player]] = []
    var cCCAA: [[Player]] = []
    private var searchResults: [[Player]]?
    var selectedIndex = 0
    private var searching: Bool = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var teamsMapView: MKMapView!
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var teamsSearchBar: UISearchBar!
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.teams = Networking.shared.playerList
        setupSubviews()
        bannerView.isHidden = true
        setupAds()
        overrideUserInterfaceStyle = .light
    }
    
    // MARK: - Methods
    
    func setupAds() {
        bannerView.delegate = self
        bannerView.adUnitID = bannerAd
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.layer.cornerRadius = 10.0
        bannerView.clipsToBounds = true
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
    
    func buttonPressed(index: Int) {
        
        if searchResults != nil {
            let team = searchResults![index]
            if let player = team.first {
                addAnnotation(player)
            }
        } else {
            switch selectedIndex {
            case 0:
                let team = divisionOne[index]
                if let player = team.first {
                    addAnnotation(player)
                }
            case 1:
                let team = divisionTwo[index]
                if let player = team.first {
                    addAnnotation(player)
                }
            case 2:
                let team = divisionThree[index]
                if let player = team.first {
                    addAnnotation(player)
                }
            case 3:
                let team = cCCAA[index]
                if let player = team.first {
                    addAnnotation(player)
                }
            default:
                return
            }
        }
    }
    
    func teamsWereFilled(list: [[Player]]) {
        let teams = list
        
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
        
        DispatchQueue.main.async {
            self.teamsTableView.reloadData()
        }
    }
    
    func setupSubviews() {
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        teamsMapView.delegate = self
        teamsMapView.mapType = MKMapType.standard
        teamsMapView.layer.cornerRadius = 10.0
        teamsMapView.clipsToBounds = true
        teamsSearchBar.delegate = self
        teamsSearchBar.tintColor = .black
        teamsSearchBar.placeholder = "Search Teams"
        teamsSearchBar.backgroundImage = UIImage()
    }
    
    func addAnnotation(_ player: Player) {
        teamsMapView.removeAnnotations(teamsMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = player.school
        let lat = CLLocationDegrees(player.lat)
        let lon = CLLocationDegrees(player.lon)
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        teamsMapView.addAnnotation(annotation)
    }
    
    private func searchForTeams(with searchTerm: String) {
        teamsMapView.removeAnnotations(teamsMapView.annotations)
        noResultsView.alpha = 0
        self.searching = true
        var results: [[Player]]?
        
        if searchTerm == "" {
            searchResults = nil
            self.searching = false
            teamsTableView.reloadData()
            return
        } else {
            switch selectedIndex {
            case 0:
                results = divisionOne.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.lowercased().contains(searchTerm.lowercased()) })
                })
            case 1:
                results = divisionTwo.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.lowercased().contains(searchTerm.lowercased()) })
                })
            case 2:
                results = divisionThree.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.lowercased().contains(searchTerm.lowercased()) })
                })
            case 3:
                results = cCCAA.filter({ (team) -> Bool in
                    team.contains(where: { $0.school.lowercased().contains(searchTerm.lowercased()) })
                })
            default:
                results = nil
            }
            if let result = results {
                if result.count == 0 {
                    self.searchResults = nil
                    noResultsView.alpha = 1
                } else {
                    self.searchResults = result
                }
            }
        }
        
        teamsTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func indexDidChange(_ sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        teamsMapView.removeAnnotations(teamsMapView.annotations)
        if teamsSearchBar.text != nil {
            searchForTeams(with: teamsSearchBar.text!)
        } else {
            teamsTableView.reloadData()
        }
        teamsTableView.setContentOffset(.zero, animated: true)
        teamsSearchBar.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rosterSegue" {
            if let detailVC = segue.destination as? TeamDetailViewController, let indexPath = teamsTableView.indexPathForSelectedRow {
                if searchResults != nil {
                    detailVC.team = searchResults![indexPath.row]
                } else {
                    switch selectedIndex {
                    case 0:
                        detailVC.team = divisionOne[indexPath.row]
                    case 1:
                        detailVC.team = divisionTwo[indexPath.row]
                    case 2:
                        detailVC.team = divisionThree[indexPath.row]
                    case 3:
                        detailVC.team = cCCAA[indexPath.row]
                    default:
                        return
                    }
                }
            }
        }
    }
}

extension TeamsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults != nil {
            return searchResults!.count
        } else {
            if searching {
                return 0
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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell else { return UITableViewCell() }
        cell.teamImageView?.image = nil
        cell.delegate = self
        cell.index = indexPath.row
        cell.regionLabel.textAlignment = NSTextAlignment.center
        
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
                cell.regionLabel.textAlignment = NSTextAlignment.left
            default:
                return UITableViewCell()
            }
        }
        
        guard let teamCell = team, let player = teamCell.first else { return UITableViewCell() }
        
        cell.teamNameLabel.text = player.school
        cell.regionLabel.text = "\(player.region)"
        let lat = Double(player.lat)
        let lon = Double(player.lon)
        cell.latLonLabel.text = "\(String(format: "%.2f", ceil(lat*100)/100)) | \(String(format: "%.2f", ceil(lon*100)/100))"
        
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
        cell.rosterButton.tintColor = .black
        cell.teamImageView.layer.borderColor = UIColor.black.cgColor
        cell.teamImageView.layer.borderWidth = 1.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        bannerView.load(GADRequest())
        teamsMapView.removeAnnotations(teamsMapView.annotations)
    }
}

extension TeamsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Annotation"
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.canShowCallout = true
        annotationView.pinTintColor = .black
        
        
        return annotationView
    }
}

extension TeamsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        searchForTeams(with: searchTerm)
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        noResultsView.alpha = 0
    }
}
