//
//  PostDetailViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit
import WebKit
import SafariServices

class PostDetailViewController: UIViewController {

    // MARK: - Properties
    
    var post: Post?
    var categories: [String]?
    
    // MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postWebView: WKWebView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var animatedLogoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backupImageView: UIImageView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setupSubviews()
    }
    
    // MARK: - Methods
    
    private func updateViews() {
        animatedLogoView.alpha = 1
        guard let post = post else { return }
        titleLabel.text = post.title.rendered.html2String.capitalized
        let cleanedText = post.content.rendered.replacingOccurrences(of: "\\/", with: "/")
        if post.content.rendered.localizedStandardContains("This content is for") == true {
            authView.isUserInteractionEnabled = true
            authView.alpha = 1
        } else {
            authView.isUserInteractionEnabled = false
            authView.alpha = 0
        }
        let header = """
                <head>
                    <meta name="viewport" content="width=100%, initial-scale=1.0, user-scalable=no" />
                    <style>
                        body {
                            font-size: 22px;
                        }
                    </style>
                </head>
                <body>
                """
        let HTMLString = HTMLImageCorrector(HTMLString: header + cleanedText)
        postWebView.loadHTMLString(HTMLString, baseURL: URL(string: "https://thejbb.net/"))
        if let imageString = post.jetpack_featured_media_url, imageString != "" {
            let url = URL(string: imageString)
            postImageView.kf.setImage(with: url)
            postImageView.alpha = 1
            backupImageView.alpha = 0
        } else {
            postImageView.alpha = 0
            backupImageView.alpha = 1
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let someDateTime = dateFormatter.date(from: post.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d, yyyy"
            let date = formatter.string(from: someDateTime)
            dateLabel.text = date
        } else {
            dateLabel.text = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.75) {
                self.animatedLogoView.alpha = 0
            }
        }
    }
    
    private func setupSubviews() {
        registerButton.layer.cornerRadius = 10
        registerButton.addShadow()
        
        categoriesCollectionView.dataSource = self
        
        postWebView.scrollView.delegate = self
        postWebView.navigationDelegate = self
        postWebView.scrollView.showsVerticalScrollIndicator = true
        postWebView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func HTMLImageCorrector(HTMLString: String) -> String {
        var HTMLToBeReturned = HTMLString
        while HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) != nil {
            if let match = HTMLToBeReturned.range(of: "(?<=width=\")[^\" height]+", options: .regularExpression) {
                HTMLToBeReturned.removeSubrange(match)
                if let matchTwo = HTMLToBeReturned.range(of: "(?<=height=\")[^\"]+", options: .regularExpression) {
                    HTMLToBeReturned.removeSubrange(matchTwo)
                    let stringToDelete = "width=\"\" height=\"\""
                    HTMLToBeReturned = HTMLToBeReturned.replacingOccurrences(of: stringToDelete, with: "")
                }
            }
        }
        return HTMLToBeReturned
    }
    
    // MARK: - Actions

    @IBAction func registerButtonTapped(_ sender: Any) {
        let url = URL(string: "https://thejbb.net/membership-account/membership-levels/")!
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension PostDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
        
        if categories?.count ?? 0 > indexPath.row {
            cell.containerView.layer.cornerRadius = 8
            cell.categoryTitleLabel.text = categories?[indexPath.row]
        }
        
        return cell
    }
}

extension PostDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                if url.absoluteString.range(of: "http://thejbb.net/wp-login.php") != nil {
                    decisionHandler(.cancel)
                    return
                } else {
                    let config = SFSafariViewController.Configuration()
                    let vc = SFSafariViewController(url: url, configuration: config)
                    present(vc, animated: true)
                    decisionHandler(.cancel)
                    return
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

extension PostDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
