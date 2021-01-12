//
//  RankingTableViewCell.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/12/21.
//

import UIKit

class RankingTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var rosterButton: UIButton!
    @IBAction func rosterButtonTapped(_ sender: Any) {
    }
}
