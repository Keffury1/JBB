//
//  PostDetailViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/21/22.
//

import UIKit
import WebKit

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
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var animatedLogoView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
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
                    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                    <style>
                        body {
                            font-size: 22px;
                        }
                    </style>
                </head>
                <body>
                """
        postWebView.loadHTMLString(header + cleanedText, baseURL: URL(string: "https://thejbb.net/"))
        let url = URL(string: post.jetpack_featured_media_url ?? "")
        postImageView.kf.setImage(with: url)
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
        loginButton.layer.cornerRadius = 10
        registerButton.layer.cornerRadius = 10
        loginButton.addShadow()
        registerButton.addShadow()
        
        categoriesCollectionView.dataSource = self
        
        postWebView.navigationDelegate = self
        postWebView.scrollView.showsVerticalScrollIndicator = false
        postWebView.scrollView.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
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
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                    return
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
