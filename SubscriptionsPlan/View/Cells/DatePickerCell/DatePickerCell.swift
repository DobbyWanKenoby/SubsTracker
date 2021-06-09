//
//  DatePickerCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 06.01.2021.
//

import UIKit

class DatePickerCell: CellWithBottomLine {
    
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellValueTextField: UITextField!
    var datePicker = UIDatePicker()
    
    // Замыкание выполняется после выбора значения в PickerView
    var onValueChange: ((UIDatePicker) -> Void)?
    
    var doneToolbarButtonColor: UIColor! {
        didSet {
            cellValueTextField.inputAccessoryView?.tintColor = doneToolbarButtonColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cellValueTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
        cellValueTextField.inputAccessoryView = getToolBar()
    }
    
    @objc func changeDate(_ picker: UIDatePicker) {
        onValueChange?(picker)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        cellValueTextField.resignFirstResponder()
    }
}
