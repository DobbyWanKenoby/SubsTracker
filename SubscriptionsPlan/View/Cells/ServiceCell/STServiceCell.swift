//
//  STServiceCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 03.01.2021.
//

import UIKit

protocol STServiceCellProtocol: STViewCellProtocol {
    var title: String { get set }
    var logo: UIImage? { get set }
    var accentColor: UIColor { get set }
}

class STServiceCell: UITableViewCell, STServiceCellProtocol {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var logo: UIImage? {
        didSet {
            logoImageView.image = logo
        }
    }
    
    var accentColor: UIColor = UIColor.clear {
        didSet {
            self.contentView.backgroundColor = accentColor
        }
    }
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        logoImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
