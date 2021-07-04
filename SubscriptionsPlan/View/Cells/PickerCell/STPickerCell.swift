//
//  PickerCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 05.01.2021.
//

import UIKit

// Данные для Picker View
// Отдельный массив для каждой секции
//  pickerRowTitle - текст, который будет выводиться в PickerView
//  instance - объект, которому соответсвует элемент PickerView
typealias PickerComponentData = [(pickerRowTitle: String, instance: Any)]

// MARK: Picker Cell Protocol

protocol STPickerCellProtocol: UITableViewCell {
    
    var title: String { get set }
    var accentColor: UIColor? { get set }
    
    var pickerViewData: [PickerComponentData] { get set }
    var selectedRows: [Int] { get set }
    var onValueChange: ((UIPickerView) -> Void)? { get set }
    
    // Временно убрано, так как не создается напрямую
//    init(title: String,
//         pickerViewData: [PickerComponentData],
//         selectedRowsInSections: [Int],
//         accentColor: UIColor?,
//         reuseIdentifier: String?)
}

// MARK: - Picker Cell Type

class STPickerCell: UITableViewCell, STPickerCellProtocol {    
    
    var pickerViewData: [PickerComponentData] = []
    
    var onValueChange: ((UIPickerView) -> Void)?

    var title: String {
        get {
            _title
        }
        set {
            _title = newValue.uppercased()
        }
    }
    private var _title: String = "" {
        didSet {
            titleLabel.text = _title
        }
    }
    
    var selectedRows: [Int] {
        didSet {
            valueLabel.selectedRows = selectedRows
        }
    }
    var accentColor: UIColor? {
        didSet {
            valueLabel.accentColor = accentColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        accentColor = .black
        self.selectedRows = []
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        createConstraints()
    }
    
//    required init(title: String, pickerViewData: [PickerComponentData], selectedRowsInSections: [Int], accentColor: UIColor?, reuseIdentifier: String?) {
//        self.selectedRows = selectedRowsInSections
//        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//        self.title = title
//        self.pickerViewData = pickerViewData
//        self.accentColor = accentColor
//
//        self.contentView.addSubview(titleLabel)
//        self.contentView.addSubview(valueLabel)
//        createConstraints()
//    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "SF Pro Rounded Semibold", size: 13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var valueLabel: STLabelPickerInputView = {
        print(selectedRows)
        let valueLabel = STLabelPickerInputView(delegateAndDataSource: self, selectedRows: selectedRows, accentColor: self.accentColor)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 20)
        valueLabel.textColor = .darkText
        
        return valueLabel
    }()
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            titleLabel.bottomAnchor.constraint(equalTo: valueLabel.topAnchor, constant: -20),
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension STPickerCell: UIPickerViewDelegate, UIPickerViewDataSource, STLabelPickerInputViewTextDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.pickerViewData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[component][row].pickerRowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRows[component] = row
        valueLabel.text = self.getTextForLabel(pickerView,forSelectedRows: selectedRows)
        valueLabel.textColor = .darkText
        onValueChange?(pickerView)
    }
    
    func getTextForLabel(_ pickerView: UIPickerView, forSelectedRows: [Int]) -> String {
        if pickerViewData.count == 0 || forSelectedRows.count == 0 {
            return ""
        }
        return pickerViewData[0][forSelectedRows[0]].pickerRowTitle
    }
}

// MARK: - Label with Picker Input View

// Делегат, который берет на себя обязанность определять текст лейбла
// в зависимости от выбранного значения в пикерах
protocol STLabelPickerInputViewTextDelegate {
    func getTextForLabel(_ pickerView: UIPickerView, forSelectedRows: [Int]) -> String
}

class STLabelPickerInputView: UILabel {
    
    private var delegate: UIPickerViewDelegate
    private var dataSource: UIPickerViewDataSource & STLabelPickerInputViewTextDelegate
    var selectedRows: [Int] = [] {
        didSet {
            for (component, selectedRow) in selectedRows.enumerated() {
                pickerView.selectRow(selectedRow, inComponent: component, animated: false)
            }
            text = dataSource.getTextForLabel(self.pickerView, forSelectedRows: selectedRows)
        }
    }
    var accentColor: UIColor? {
        didSet {
            toolBar.items?.forEach { item in
                item.tintColor = accentColor
            }
        }
    }
    // ссылка на тулбар, чтобы менять цвет его элементов
    private var toolBar: UIToolbar!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(title: NSLocalizedString("done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.hidePicker))
        if let color = accentColor {
            doneButton.tintColor = color
            toolBar.tintColor = color
        }
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    var pickerView: UIPickerView {
        inputView as! UIPickerView
    }
    
    override var inputView: UIView? {
        let picker = UIPickerView()
        picker.delegate = delegate
        picker.dataSource = dataSource
        for (component, selectedRow) in selectedRows.enumerated() {
            picker.selectRow(selectedRow, inComponent: component, animated: false)
        }
        return picker
    }
    
    init(delegateAndDataSource: UIPickerViewDelegate & UIPickerViewDataSource & STLabelPickerInputViewTextDelegate, selectedRows: [Int], accentColor: UIColor?) {
        delegate = delegateAndDataSource
        dataSource = delegateAndDataSource
        super.init(frame: CGRect.zero)
        addGesture()
        inputAccessoryView?.tintColor = accentColor
        self.isUserInteractionEnabled = true
        self.selectedRows = selectedRows
        self.accentColor = accentColor
        text = dataSource.getTextForLabel(self.pickerView, forSelectedRows: selectedRows)
        //self.pickerView.selectRow(1, inComponent: 0, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPicker))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func showPicker() {
        becomeFirstResponder()
    }
    
    @objc private func hidePicker() {
        resignFirstResponder()
    }
}
