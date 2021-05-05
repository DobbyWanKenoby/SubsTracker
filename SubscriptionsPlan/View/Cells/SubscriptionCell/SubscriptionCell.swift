//
//  SubscriptionCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 01.01.2021.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    
    @IBOutlet var baseColorView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseColorView.layer.cornerRadius = 10
        logoImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
