//
//  CheckboxCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 13.01.2021.
//

import UIKit

protocol STSwitchCellProtocol: STInputCellProtocol {
    var title: String { get set }
    var isActivate: Bool { get set }
    var accentColor: UIColor { get set }
    var didValueChanged: ((UISwitch) -> Void)? { get set }
}

class STSwitchCell: UITableViewCell, STSwitchCellProtocol {
    var onSelectAnyCellElement: (() -> Void)?
    
    var title: String = "" {
        didSet {
            cellTitleLabel.text = title
        }
    }
    
    var isActivate: Bool  = false {
        didSet {
            cellSwitch.isOn = isActivate
        }
    }
    
    var accentColor: UIColor = UIColor.clear {
        didSet {
            cellSwitch.onTintColor = accentColor
        }
    }
    
    var didValueChanged: ((UISwitch) -> Void)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        onSelectAnyCellElement?()
        return super.hitTest(point, with: event)
    }
    
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        cellSwitch.addTarget(self, action: #selector(onChangeValueInSwitch(_:)), for: .valueChanged)
    }
    
    @objc func onChangeValueInSwitch(_ sender: UISwitch) {
        didValueChanged?(sender)
    }
    
}
