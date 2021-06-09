//
//  CheckboxCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 13.01.2021.
//

import UIKit

class SwitchCell: CellWithBottomLine {
    
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellSwitch: UISwitch!
    
    var onValueChange: ((UISwitch) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        cellSwitch.addTarget(self, action: #selector(onChangeValueInSwitch(_:)), for: .valueChanged)
    }
    
    @objc func onChangeValueInSwitch(_ sender: UISwitch) {
        onValueChange?(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
