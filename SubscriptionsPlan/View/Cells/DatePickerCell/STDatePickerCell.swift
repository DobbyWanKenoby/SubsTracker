//
//  DatePickerCell.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 06.01.2021.
//

import UIKit

// MARK: Picker Cell Protocol

protocol STDatePickerCellProtocol: UITableViewCell, STInputCellProtocol {
    
    var title: String { get set }
    var accentColor: UIColor? { get set }
    
    var selectedDate: Date { get set }
    var didDateChanged: ((Date) -> Void)? { get set }
    
}

// MARK: - Picker Cell Type

class STDatePickerCell: UITableViewCell, STDatePickerCellProtocol, STDateLabelPickerInputViewDelegate {
    var onSelectAnyCellElement: (() -> Void)?
    
    func didPickerValueChanged(date: Date) {
        didDateChanged?(date)
    }
    
    var selectedDate: Date = Date() {
        didSet {
            valueLabel.selectedDate = selectedDate
        }
    }
      
    var didDateChanged: ((Date) -> Void)?

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
    
    var accentColor: UIColor? {
        didSet {
            valueLabel.accentColor = accentColor
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        onSelectAnyCellElement?()
        return super.hitTest(point, with: event)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        accentColor = .black
        self.selectedDate = Date()
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(valueLabel)
        createConstraints()
        valueLabel.tag = 1
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "SF Pro Rounded Semibold", size: 13)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    lazy var valueLabel: STLabelDatePickerInputView = {
        let valueLabel = STLabelDatePickerInputView(selectedDate: selectedDate, accentColor: accentColor)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 20)
        valueLabel.textColor = .darkText
        valueLabel.delegate = self
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

// MARK: - Label with Date Picker Input View

protocol STDateLabelPickerInputViewDelegate {
    // Дата была изменена
    func didPickerValueChanged(date: Date)
}

class STLabelDatePickerInputView: UILabel {
    
    var delegate: STDateLabelPickerInputViewDelegate?
    
    var selectedDate: Date = Date() {
        didSet {
            datePicker.setDate(selectedDate, animated: true)
            text = getDateLocaleFormat(selectedDate)
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
    
    var datePicker: UIDatePicker {
        inputView as! UIDatePicker
    }
    
    override var inputView: UIView? {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
        datePicker.setDate(selectedDate, animated: true)
        return datePicker
    }
    
    @objc func changeDate(_ picker: UIDatePicker) {
        selectedDate = picker.date
        delegate?.didPickerValueChanged(date: picker.date)
    }
    
    init(selectedDate: Date, accentColor: UIColor?) {
        self.selectedDate = selectedDate
        super.init(frame: CGRect.zero)
        addGesture()
        inputAccessoryView?.tintColor = accentColor
        self.isUserInteractionEnabled = true
        self.selectedDate = selectedDate
        self.accentColor = accentColor
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

//class STDatePickerCell: CellWithBottomLine {
//    
//    @IBOutlet var cellTitleLabel: UILabel!
//    @IBOutlet var cellValueTextField: TextField!
//    var datePicker = UIDatePicker()
//    
//    // Замыкание выполняется после выбора значения в PickerView
//    var onValueChange: ((UIDatePicker) -> Void)?
//    
//    var doneToolbarButtonColor: UIColor! {
//        didSet {
//            cellValueTextField.inputAccessoryView?.tintColor = doneToolbarButtonColor
//        }
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        cellValueTextField.inputView = datePicker
//        datePicker.datePickerMode = .date
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .wheels
//        }
//        datePicker.locale = Locale.current
//        datePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
//        cellValueTextField.inputAccessoryView = getToolBar()
//    }
//    
//    @objc func changeDate(_ picker: UIDatePicker) {
//        onValueChange?(picker)
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//    
//    func getToolBar() -> UIToolbar{
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        toolBar.setItems([spaceButton,spaceButton,doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        toolBar.sizeToFit()
//        return toolBar
//    }
//    
//    @objc func donePressed() {
//        cellValueTextField.resignFirstResponder()
//    }
//}
