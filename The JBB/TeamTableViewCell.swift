//
//  TeamTableViewCell.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/5/21.
//

import UIKit

protocol TableViewCellDelegate {
    func buttonPressed(index: Int)
}

class TeamTableViewCell: UITableViewCell {
    
    var delegate: TableViewCellDelegate?
    
    var index: Int?

    @IBOutlet weak var rosterButton: UIButton!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBAction func rosterButtonTapped(_ sender: Any) {
        guard let index = index else { return }
        delegate?.buttonPressed(index: index)
    }
}
