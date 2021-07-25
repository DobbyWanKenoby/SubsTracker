//
//  TextFieldCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import UIKit

protocol STTextFieldCellProtocol: STInputCellProtocol {
    var title: String { get set }
    var value: String { get set }
    var accentColor: UIColor { get set }
    var didValueChanged: ((UITextField) -> Void)? { get set }
}

class STTextFieldCell: UITableViewCell, STTextFieldCellProtocol {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var value: String = "" {
        didSet {
            textField.text = title
        }
    }
    
    var accentColor: UIColor = UIColor.clear {
        didSet {
            textField.inputAccessoryView?.tintColor = accentColor
        }
    }
    
    var onSelectAnyCellElement: (() -> Void)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        onSelectAnyCellElement?()
        return super.hitTest(point, with: event)
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var didValueChanged: ((UITextField) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.inputAccessoryView = getToolBar()
    }
    
    func getToolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: NSLocalizedString("done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func donePressed() {
        didValueChanged?(textField)
        textField.resignFirstResponder()
    }
    
    @IBAction func textFieldEditingEnded(_ sender: UITextField) {
        didValueChanged?(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

