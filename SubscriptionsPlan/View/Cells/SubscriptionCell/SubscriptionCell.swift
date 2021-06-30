//
//  SubscriptionCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 01.01.2021.
//

import UIKit



class SubscriptionCell: UITableViewCell {
    
    var withRoundedCorners: Bool = true
    
    @IBOutlet var baseColorView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeRemain: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if withRoundedCorners {
            baseColorView.layer.cornerRadius = 10
            logoImageView.layer.cornerRadius = 10
            headerView.layer.cornerRadius = 10
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
