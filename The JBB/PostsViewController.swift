//
//  PostsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/29/22.
//

import UIKit
import Kingfisher
import Firebase
import GoogleMobileAds

class PostsViewController: UIViewController {

    // MARK: - Properties

    var posts: [Post] = []
    var searchedPosts: [Post] = []
    var categories: [Category] = []
    var row: Int?
    var offset = 0
    var searchOffset = 0
    var reachedEndOfItems = false
    var isSearching = false
    var searchTerm: String?
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    var adLoader: GADAdLoader!

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animatedLogoView: UIView!
    @IBOutlet weak var animatedLogo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topButton: UIButton!
    
    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAds()
        fetchCategories()
        fetchPosts()
        setupSubviews()
    }

    // MARK: - Methods

    private func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.white.cgColor
        animatedLogo.heartbeatAnimation()
        animatedLogo.startAnimating()
        topButton.setTitle("", for: .normal)
    }
    
    private func loadAds() {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = numAdsToLoad
        
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }

    private func fetchPosts() {
        Networking.shared.getAllPosts(offset: offset, searchTerm: nil) { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.offset += 25
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self.animatedLogoView.alpha = 0
                    self.animatedLogo.stopAnimating()
                }
            }
        } onError: { errorMessage in
            print(errorMessage ?? "")
        }
    }
    
    private func fetchCategories() {
        Networking.shared.getAllCategories { categories in
            self.categories = categories
        } onError: { errorMessage in
            print(errorMessage ?? "")
        }
    }
    
    private func loadMore() {
        guard !self.reachedEndOfItems else {
            return
        }

        loadAds()

        if isSearching {
            DispatchQueue.global(qos: .background).async {
                var thisBatchOfItems: [Post]?
        
                Networking.shared.getAllPosts(offset: self.searchOffset, searchTerm: self.searchTerm, onSuccess: { posts in
                    thisBatchOfItems = posts
                    DispatchQueue.main.async {
                        if let newItems = thisBatchOfItems {
                            self.searchedPosts.append(contentsOf: newItems)
                            self.tableView.reloadData()
                            self.tableView.tableFooterView = nil
                            self.tableView.tableFooterView?.isHidden = true
                            if newItems.count < 25 {
                                self.reachedEndOfItems = true
                            }
                            self.searchOffset += 25
                        }
                    }
                }) { errorMessage in
                    print("query failed")
                }
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                var thisBatchOfItems: [Post]?
        
                Networking.shared.getAllPosts(offset: self.offset, searchTerm: nil, onSuccess: { posts in
                    thisBatchOfItems = posts
                    DispatchQueue.main.async {
                        if let newItems = thisBatchOfItems {
                            self.posts.append(contentsOf: newItems)
                            self.tableView.reloadData()
                            self.tableView.tableFooterView = nil
                            self.tableView.tableFooterView?.isHidden = true
                            if newItems.count < 25 {
                                self.reachedEndOfItems = true
                            }
                            self.offset += 25
                        }
                    }
                }) { errorMessage in
                    print("query failed")
                }
            }
        }
    }
    
    private func translateCategories(_ post_categories: [Int]) -> [String] {
        var strings: [String] = []

        for post_category in post_categories {
            strings.append(categories.first(where: { $0.id == post_category })?.name ?? "")
        }

        return strings
    }
    
    // MARK: - Actions
    
    @IBAction func topButtonTapped(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue" {
            if let detailVC = segue.destination as? PostDetailViewController {
                if isSearching {
                    detailVC.post = searchedPosts[row! - (row! / 5)]
                    detailVC.categories = translateCategories(searchedPosts[row!].categories ?? [])
                } else {
                    detailVC.post = posts[row! - (row! / 5)]
                    detailVC.categories = translateCategories(posts[row!].categories ?? [])
                }
            }
        }
    }
}

extension PostsViewController: PostTVCellDelegate {
    func buttonTapped(int: Int) {
        row = int
        self.performSegue(withIdentifier: "postDetailSegue", sender: self)
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return searchedPosts.count
        } else {
            return posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 5 == 0) && indexPath.row != 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath) as? AdTableViewCell else { return UITableViewCell() }
            
            let ad = nativeAds[indexPath.row / 5]

            cell.adTitleLabel.text = ad.headline?.capitalized
            cell.adDetailLabel.text = ad.body
            cell.mediaView.mediaContent = ad.mediaContent
            cell.callToActionButton.setTitle(ad.callToAction, for: .normal)
            cell.nativeAdView.nativeAd = ad
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

            var post: Post?
            
            if isSearching == true {
                post = searchedPosts[indexPath.row - (indexPath.row / 5)]
                if indexPath.row == self.searchedPosts.count - 1 {
                    self.loadMore()
                }
            } else {
                post = posts[indexPath.row - (indexPath.row / 5)]
                if indexPath.row == self.posts.count - 1 {
                    self.loadMore()
                }
            }

            if let post = post {
                cell.postCategories = translateCategories(post.categories ?? [])
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                if let someDateTime = dateFormatter.date(from: post.date) {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEEE, MMM d, yyyy"
                    let date = formatter.string(from: someDateTime)
                    cell.dateLabel.text = date
                } else {
                    cell.dateLabel.text = ""
                }
                cell.titleLabel.text = post.title.rendered.html2String.capitalized
                let url = URL(string: post.jetpack_featured_media_url ?? "")
                cell.postImageView.kf.setImage(with: url)
                cell.postTVCellDelegate = self
                cell.indexPath = indexPath
            } else {
                
            }

            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = UIColor(named: "Teel")
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
        }
    }
}

extension PostsViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            isSearching = false
        } else {
            isSearching = true
            self.searchTerm = searchBar.text
            searchedPosts = posts.filter( { $0.title.rendered.html2String.lowercased().contains(searchBar.text!.lowercased())} )
            searchOffset = searchedPosts.count
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}

extension PostsViewController: GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAd.delegate = self
        nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Error loading Native Ad: \(error)")
    }
}
