//
//  RankingsViewController.swift
//  The JBB
//
//  Created by Bobby Keffury on 12/22/20.
//

import UIKit

class RankingsViewController: UIViewController {

    // MARK: - Properties
    
    var leader: Ranking?
    
    // MARK: - Outlets
    
    @IBOutlet weak var divisionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var leaderNameLabel: UILabel!
    @IBOutlet weak var leaderRecordLabel: UILabel!
    @IBOutlet weak var leaderChangeLabel: UILabel!
    @IBOutlet weak var leaderImageView: UIImageView!
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}

extension RankingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as? TeamCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
}
