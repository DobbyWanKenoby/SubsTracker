//
//  AddSubOverlayView.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

class AddSubscriptionController: UIViewController, AddSubscriptionProtocol {

    // MARK: Input Data
    var subscription: AddSubscriptionElement!
    
    // MARK: Output Callbacks
    var onCancelScene: ((AddSubscriptionElement?) -> Void)?
    var onSaveSubscription: ((AddSubscriptionElement) -> Void)?
    
    // MARK: Helpers
    // редактируемое текстовое поле
    // используется при показе клавиатуры и сдвиге поля вверх (чтобы не закрывалось клавиатурой)
    private var editingTextField: UITextField!
    // Изначальные координаты корневого view
    // используется при протягивании сцены вверх и вниз для возврата
    private var originPoint: CGPoint!
    
    // MARK: Outlets
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var serviceTitle: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeader()
        configureButtons()
        registerCells()
        addKeyboardObserver()
        addGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() {
        if originPoint == nil {
            originPoint = self.view.frame.origin
        }
    }

    private func addGestureRecognizer() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerHandler(_:)))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func gestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view.superview)
        view.frame.origin = CGPoint(x:0, y: Int(translation.y) + Int(originPoint.y))
        if sender.state == .ended {
            let duration = 0.02 * Double((sender.location(in: view.superview).y) / 100)
            UIView.animate(withDuration: 0.15 + duration, animations: {
                self.view.frame.origin = self.originPoint
            })
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func registerCells(){
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "PickerCell")
        tableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: "DatePickerCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
    }
    
    // отодвигаем текстовое поле, чтобы его было видно над клавиатурой
    @objc func keyboardWillShow(_ notification: Notification) {
        if editingTextField == nil {
            return
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let globalPoint = editingTextField.superview?.convert(editingTextField.frame.origin, to: tableView)
            let screenHeight = UIScreen.main.bounds.size.height
            if screenHeight - keyboardHeight < globalPoint!.y + 80 {
                let offset = keyboardHeight - (screenHeight - globalPoint!.y) + 150
                tableView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            }
        }
    }
    
    private func configureHeader() {
        headerView.backgroundColor = subscription.service.color
        serviceImage.image = subscription.service.logo
        serviceImage.layer.cornerRadius = 10
        serviceTitle.text = subscription.service.title
    }
    
    private func configureButtons() {
        saveButton.backgroundColor = subscription.service.color
        saveButton.layer.cornerRadius = 10
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        backButton.layer.cornerRadius = 10
        backButton.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
    }
    
    // MARK: Actions
    @IBAction func dismissController() {
        onCancelScene?(subscription)
        //self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissControllerWithSuccess() {
        onSaveSubscription?(subscription)
        //self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Data Source

extension AddSubscriptionController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch (subscription.isCustomService, indexPath.row) {
        case (let isCustom, let numRow) where (isCustom == false && numRow == 0) || (isCustom == true && numRow == 2):
            cell = getAmounCell()
        case (let isCustom, let numRow) where (isCustom == false && numRow == 1) || (isCustom == true && numRow == 3):
            cell = getCurrencyCell()
        case (let isCustom, let numRow) where (isCustom == false && numRow == 2) || (isCustom == true && numRow == 4):
            cell = getDateCell()
        case (let isCustom, let numRow) where (isCustom == false && numRow == 3) || (isCustom == true && numRow == 5):
            cell = getPeriodCell()
        case (let isCustom, let numRow) where (isCustom == false && numRow == 4) || (isCustom == true && numRow == 6):
            cell = getNoticeCell()
        case (let isCustom, let numRow) where (isCustom == false && numRow == 5) || (isCustom == true && numRow == 7):
            cell = getNotificationCell()
        case (let isCustom, let numRow) where (isCustom == false && numRow == 6) || (isCustom == true && numRow == 8):
            cell = getNotificationPeriodCell()
        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    private func getNotificationPeriodCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell") as! PickerCell
        return configureNotificationPeriodCell(cell)
    }
    
    private func configureNotificationPeriodCell(_ cell: PickerCell) -> PickerCell {
        cell.cellTitleLabel.text = NSLocalizedString("notification period", comment: "")
        cell.pickerComponentsCount = 1
        cell.pickerViewDataItems = [Array(1...31)]
        cell.titleForRowInDataItems = { _, row in
            return String(cell.pickerViewDataItems[0][row] as! Int)
        }
        cell.isSetBottomLine = true
        cell.pickerView.selectRow(subscription.notificationDaysPeriod - 1, inComponent: 0, animated: false)
        cell.cellValueTextField.text = String(format: NSLocalizedString("in %d days", comment: ""), subscription.notificationDaysPeriod)
        cell.onValueChange = { pickerView in
            let selectedNumber = cell.pickerViewDataItems[0][pickerView.selectedRow(inComponent: 0)] as! Int
            self.subscription.notificationDaysPeriod = Int(selectedNumber)
            cell.cellValueTextField.text = String(format: NSLocalizedString("in %d days", comment: ""), selectedNumber)
        }
        cell.doneToolbarButtonColor = subscription.service.color
        cell.cellValueTextField.delegate = self
        return cell
    }
    
    private func getNotificationCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
        return configureNotificationCell(cell)
    }
    
    private func configureNotificationCell( _ cell: SwitchCell) -> SwitchCell {
        cell.cellSwitch.onTintColor = subscription.service.color
        cell.cellSwitch.isOn = subscription.isNotificationable
        cell.isSetBottomLine = true
        cell.cellTitleLabel.text = NSLocalizedString("notify", comment: "")
        cell.onValueChange = { switchElement in
            self.subscription.isNotificationable = switchElement.isOn
        }
        return cell
    }
    
    private func getPeriodCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell") as! PickerCell
        return configurePeriodCell(cell)
    }
    
    private func configurePeriodCell(_ cell: PickerCell) -> PickerCell {
        cell.cellTitleLabel.text = NSLocalizedString("payment period", comment: "")
        cell.pickerComponentsCount = 2
        cell.pickerViewDataItems = [
            Array(1...30),
            PeriodType.allCases
        ]
        cell.titleForRowInDataItems = { components, row in
            let resultString: String
            switch components {
            case 0:
                resultString = String(cell.pickerViewDataItems[0][row] as! Int)
            case 1:
                resultString = (cell.pickerViewDataItems[1][row] as! PeriodType).getLocaleTitle()
            default:
                resultString = ""
            }
            return resultString
        }
        cell.isSetBottomLine = true
        let defaultValueIndexComponent1 = (cell.pickerViewDataItems[1] as! [PeriodType]).firstIndex(of: subscription.paymentPeriod.1)
        cell.pickerView.selectRow(subscription.paymentPeriod.0 - 1, inComponent: 0, animated: false)
        cell.pickerView.selectRow(defaultValueIndexComponent1!, inComponent: 1, animated: false)
        cell.cellValueTextField.text = "\(NSLocalizedString("every", comment: "")) \(self.subscription.paymentPeriod.0) \(self.subscription.paymentPeriod.1.getLocaleTitle())"
        cell.onValueChange = { pickerView in
            let selectedNumber = cell.pickerViewDataItems[0][pickerView.selectedRow(inComponent: 0)] as! Int
            let selectedPeriodType = cell.pickerViewDataItems[1][pickerView.selectedRow(inComponent: 1)] as! PeriodType
            self.subscription.paymentPeriod = (selectedNumber, selectedPeriodType)
            cell.cellValueTextField.text = "\(NSLocalizedString("every", comment: "")) \(self.subscription.paymentPeriod.0) \(self.subscription.paymentPeriod.1.getLocaleTitle())"
        }
        cell.doneToolbarButtonColor = subscription.service.color
        cell.cellValueTextField.delegate = self
        return cell
    }
    
    private func getDateCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
        cell.cellValueTextField.delegate = self
        return configureDateCell(cell)
    }
    
    private func configureDateCell(_ cell: DatePickerCell) -> DatePickerCell {
        cell.cellTitleLabel.text = NSLocalizedString("next_payment", comment: "")
        cell.isSetBottomLine = true
        cell.doneToolbarButtonColor = subscription.service.color
        cell.datePicker.date = subscription.date
        cell.cellValueTextField.text = getDateLocaleFormat(subscription.date)
        cell.onValueChange = { pickerView in
            self.subscription.date = pickerView.date
            cell.cellValueTextField.text = getDateLocaleFormat(self.subscription.date)
        }
        cell.cellValueTextField.delegate = self
        return cell
    }
    
    private func getCurrencyCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell") as! PickerCell
        return configureCurrencyCell(cell)
    }
    
    private func configureCurrencyCell(_ cell: PickerCell) -> PickerCell {
        cell.cellTitleLabel.text = NSLocalizedString("currency", comment: "")
        cell.pickerComponentsCount = 1
        cell.pickerViewDataItems = [CurrencyStorage.default.getAll()]
        cell.titleForRowInDataItems = { _, row in
            let resultString = "\((cell.pickerViewDataItems[0][row] as! CurrencyProtocol).title) (\((cell.pickerViewDataItems[0][row] as! CurrencyProtocol).symbol))"
            return resultString
        }
        cell.isSetBottomLine = true
        let indexOfDefaultValue = CurrencyStorage.default.getAll().firstIndex(where: {$0.identifier == Settings.shared.defaultCurrency.identifier})!
        cell.pickerView.selectRow(Int(indexOfDefaultValue), inComponent: 0, animated: false)
        cell.cellValueTextField.text = "\(self.subscription.currency.title) (\(self.subscription.currency.symbol))"
        cell.doneToolbarButtonColor = subscription.service.color
        cell.onValueChange = { pickerView in
            self.subscription.currency = cell.pickerViewDataItems[0][pickerView.selectedRow(inComponent: 0)] as! CurrencyProtocol
            cell.cellValueTextField.text = "\(self.subscription.currency.title) (\(self.subscription.currency.symbol))"
        }
        cell.cellValueTextField.delegate = self
        return cell
    }
    
    private func getAmounCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
        cell.cellValueTextField.delegate = self
        return configureAmountCell(cell)
    }
    
    private func configureAmountCell(_ cell: TextFieldCell) -> TextFieldCell {
        cell.cellTitleLabel.text = NSLocalizedString("amount", comment: "")
        cell.cellValueTextField.placeholder = "0.00"
        cell.cellValueTextField.text = getAmountFormattedString(String(subscription.amount))
        cell.cellValueTextField.keyboardType = .numberPad
        cell.cellValueTextField.addTarget(nil, action: #selector(amountTextFieldValueDidChanged(_:)), for: .editingChanged)
        cell.isSetBottomLine = true
        cell.doneToolbarButtonColor = subscription.service.color
        return cell
    }
    
    @objc func amountTextFieldValueDidChanged(_ textField: UITextField) {
        guard let textFieldValue = textField.text else {
            return
        }
        textField.text = getAmountFormattedString(textFieldValue)
        subscription.amount = Float(textField.text!)!
    }
    
    private func getAmountFormattedString(_ value: String) -> String {
        var editableValue = value
        let numberSections = value.split(separator: ".")
        if numberSections[1].count == 1 {
            editableValue = "\(value)0"
        }
        var number = Float((editableValue.replacingOccurrences(of: ".", with: "")))!
        number = number / 100
        return String(format: "%.2f", arguments: [number])
    }
    
    private func getNoticeCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
        cell.cellTitleLabel.text = NSLocalizedString("notice", comment: "")
        cell.cellTitleLabel.text = NSLocalizedString("notice", comment: "")
        cell.cellValueTextField.placeholder = NSLocalizedString("notice", comment: "")
        cell.isSetBottomLine = true
        cell.cellValueTextField.delegate = self
        cell.onValueChange = { textField in
            guard let textNotice = textField.text else {
                self.subscription.notice = ""
                return
            }
            self.subscription.notice = textNotice
        }
        return cell
    }
}

// MARK: - Table View Delegate

extension AddSubscriptionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.viewWithTag(1)?.becomeFirstResponder()
    }
}

// MARK: - Text Field Delegate

extension AddSubscriptionController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.editingTextField = textField
    }
}
