//
//  TextFieldCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import UIKit

class TextFieldCell: CellWithBottomLine {
    
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellValueTextField: TextField!
    
    var onValueChange: ((UITextField) -> Void)?
    
    var doneToolbarButtonColor: UIColor! {
        didSet {
            cellValueTextField.inputAccessoryView?.tintColor = doneToolbarButtonColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cellValueTextField.inputAccessoryView = getToolBar()
    }
    
    func getToolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func donePressed() {
        onValueChange?(cellValueTextField)
        cellValueTextField.resignFirstResponder()
    }
    
    @IBAction func textFieldEditingEnded(_ sender: UITextField) {
        onValueChange?(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

