//
//  PickerCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import UIKit

class PickerCell: CellWithBottomLine {
    
    // количество секций для пикера
    var pickerComponentsCount: Int!
    // Данные для Picker View
    // Отдельный массив для каждой секции
    var pickerViewDataItems: [[Any]] = []
    // Замыкание возвращает title для очередной строки PickerView
    // IndexPath - section и row выбранного значения
    var titleForRowInDataItems: ((_ component: Int, _ row: Int) -> String)!
    // Замыкание выполняется после выбора значения в PickerView
    var onValueChange: ((UIPickerView) -> Void)?
    
    var doneToolbarButtonColor: UIColor! {
        didSet {
            cellValueTextField.inputAccessoryView?.tintColor = doneToolbarButtonColor
        }
    }

    
    @IBOutlet var cellTitleLabel: UILabel!
    @IBOutlet var cellValueTextField: UITextField!
    var pickerView = UIPickerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        cellValueTextField.inputView = pickerView
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
        cellValueTextField.resignFirstResponder()
    }
}

extension PickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponentsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.pickerViewDataItems[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titleForRowInDataItems(component, row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onValueChange?(pickerView)
    }
    
}
