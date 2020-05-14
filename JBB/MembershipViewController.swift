//
//  MembershipViewController.swift
//  JBB
//
//  Created by Bobby Keffury on 5/1/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import UIKit

class MembershipViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //MARK: - Properties
    
    var memberships: [Membership] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var membershipCollectionView: UICollectionView!
    
    //MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        addMembership()
        membershipCollectionView.delegate = self
        membershipCollectionView.dataSource = self
    }
    
    
    //MARK: - Methods
    
    private func setupSubviews() {
        subscribeButton.layer.cornerRadius = 10.0
        subscribeButton.layer.borderWidth = 2.0
        subscribeButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func addMembership() {
        let oneYear = Membership(year: "1 Year", price: "$1.99 / month", archived: "✓ Archived Content", premium: "✓ Premium Content", adFree: "✓ Ad-Free", annualSubscription: nil)
        let twoYear = Membership(year: "2 Year", price: "$1.67 / month", archived: "✓ Archived Content", premium: "✓ Premium Content", adFree: "✓ Ad-Free", annualSubscription: "✓ Annual Subscription")
        let fiveYear = Membership(year: "5 Year", price: "$1.25 / month", archived: "✓ Archived Content", premium: "✓ Premium Content", adFree: "✓ Ad-Free", annualSubscription: "✓ Annual Subscription")
        memberships.append(oneYear)
        memberships.append(twoYear)
        memberships.append(fiveYear)
        
        membershipCollectionView.reloadData()
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "membershipCell", for: indexPath) as? MembershipCollectionViewCell else { return UICollectionViewCell() }
        
        let membership = memberships[indexPath.row]
        
        cell.yearLabel.text = membership.year
        cell.priceLabel.text = membership.price
        cell.archivedLabel.text = membership.archived
        cell.premiumLabel.text = membership.premium
        cell.adFreeLabel.text = membership.adFree
        cell.annualSubscriptionLabel.text = membership.annualSubscription
        cell.layer.cornerRadius = 20.0
        
        return cell
    }
    
    //MARK: - Actions
    
    @IBAction func subscribeButtonTapped(_ sender: Any) {
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
