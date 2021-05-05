//
//  CellTitleLabel.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import UIKit

class CellTitleLabel: UILabel {
    override var text: String? {
        didSet {
            super.text = text?.uppercased()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        super.text = text?.uppercased()
    }
}
