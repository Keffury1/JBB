//
//  AdTableViewCell.swift
//  The JBB
//
//  Created by Bobby Keffury on 1/30/22.
//

import UIKit
import Firebase

class AdTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nativeAdView: GADUnifiedNativeAdView!
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adDetailLabel: UILabel!
    @IBOutlet weak var mediaView: GADMediaView!
    @IBOutlet weak var callToActionView: UIView!
    
    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        setupSubviews()
    }
    
    private func setupSubviews() {
        callToActionView.layer.cornerRadius = 10
        nativeAdView.layer.cornerRadius = 10
        mediaView.layer.cornerRadius = 10
    }
}
