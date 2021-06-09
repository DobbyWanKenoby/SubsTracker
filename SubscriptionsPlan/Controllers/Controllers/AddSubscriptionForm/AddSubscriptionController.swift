//
//  AddSubOverlayView.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

protocol AddSubscriptionControllerProtocol: Receiver where Self: UIViewController {
    // Input Data
    var subscription: SubscriptionProtocol? { get set }
    var service: ServiceProtocol? { get set }
    var currencies: [CurrencyProtocol]! { get set }
    // Требуется передать значение, если свойство subscription не установлено
    // Принудительно устанавливает переключатель валюты в указанное значение
    var currentCurrency: CurrencyProtocol? { get set }
    
    // Output Callbacks
    var onCancelScene: ((SubscriptionProtocol?) -> Void)? { get set }
    var onSaveSubscription: ((_ subscription: SubscriptionProtocol, _ isNewService: Bool) -> Void)? { get set }
}

class AddSubscriptionController: UIViewController, AddSubscriptionControllerProtocol {

    // MARK: Input Data
    var subscription: SubscriptionProtocol? {
        didSet(currency) {
            if currency != nil {
                // toDo
            }
        }
    }
    var service: ServiceProtocol?
    var currencies: [CurrencyProtocol]!
    var currentCurrency: CurrencyProtocol? {
        didSet(currency) {
            if currency != nil {
                subscriptionCurrency = currency
            }
        }
    }
    
    // MARK: Output Callbacks
    var onCancelScene: ((SubscriptionProtocol?) -> Void)?
    var onSaveSubscription: ((_ subscription: SubscriptionProtocol, _ isNewService: Bool) -> Void)?
    
    // MARK: Helpers
    // редактируемое текстовое поле
    // используется при показе клавиатуры и сдвиге поля вверх (чтобы не закрывалось клавиатурой)
    private var editingTextField: UITextField!
    // Изначальные координаты корневого view
    // используется при протягивании сцены вверх и вниз для возврата
    private var originPoint: CGPoint!
    // основной цвет сцены
    private var color: UIColor! {
        get {
            guard service != nil else {
                return UIColor.gray
            }
            return service!.color
        }
    }
    
    // редактируемые данные
    // далее они будут сохранены в свойство subscription
    var serviceLogo: UIImage = UIImage(named: "1password")!
    var serviceTitle: String = "Новый сервис"
    var subscriptionNotificationDaysPeriod: Int = 1
    var subscriptionNotificationable: Bool = true
    var subscriptionPaymentPeriod: (Int, PeriodType) = (1, .month)
    var subscriptionNextPaymentDate = Date()
    var subscriptionDescription: String = ""
    var subscriptionCurrency: CurrencyProtocol!
    var subscriptionAmount: Float = 0
    
    // MARK: Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeader()
        registerCells()
        addKeyboardObserver()
        addGestureRecognizer()
        
        if subscriptionCurrency == nil {
            subscriptionCurrency = currencies.first!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureButtons()
        self.tableView.reloadData()
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
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
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
        //headerView.backgroundColor = subscription.service.color
        //serviceImage.image = subscription.service.logo
        //serviceImage.layer.cornerRadius = 10
        //serviceTitle.text = subscription.service.title
    }
    
    private func configureButtons() {
        saveButton.backgroundColor = color
        saveButton.layer.cornerRadius = 10
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        backButton.layer.cornerRadius = 10
        backButton.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
    }
    
    // MARK: Actions
    @IBAction func dismissController() {
        //onCancelScene?(subscription)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissControllerWithSuccess() {
        //let newSubscription = 
        //onSaveSubscription?(subscription)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table View Data Source

extension AddSubscriptionController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return UITableView().estimatedRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if service != nil {
            cell = getCellIfServiceExists(indexPath: indexPath)
        } else {
            // toDO: Реализовать верный метод
            cell = getCellIfServiceExists(indexPath: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // возвращает ячейку в случае, когда подписка создается на основе существующего сервиса
    private func getCellIfServiceExists(indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch (indexPath.row) {
        case 0:
            cell = getServiceCell()
        case 1:
            cell = getAmounCell()
        case 2:
            cell = getCurrencyCell()
        case 3:
            cell = getDateCell()
        case 4:
            cell = getPeriodCell()
        case 5:
            cell = getNoticeCell()
        case 6:
            cell = getNotificationCell()
        case 7:
            cell = getNotificationPeriodCell()
        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            break
        }
        return cell
    }
    
    private func getServiceCell() -> ServiceCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        cell.logoImageView.image = serviceLogo
        cell.titleLabel.text = serviceTitle
        cell.contentView.backgroundColor = color
        // скрываем первую ячейку
        // она не нужна так как сверху перекрыта новой в ходе анимации
        cell.contentView.layer.opacity = 0
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
        cell.pickerView.selectRow(subscriptionNotificationDaysPeriod - 1, inComponent: 0, animated: false)
        cell.cellValueTextField.text = String(format: NSLocalizedString("in %d days", comment: ""), subscriptionNotificationDaysPeriod)
        
        cell.onValueChange = { pickerView in
            let selectedNumber = cell.pickerViewDataItems[0][pickerView.selectedRow(inComponent: 0)] as! Int
            self.subscriptionNotificationDaysPeriod = Int(selectedNumber)
            cell.cellValueTextField.text = String(format: NSLocalizedString("in %d days", comment: ""), selectedNumber)
        }
        cell.doneToolbarButtonColor = color
        cell.cellValueTextField.delegate = self
        return cell
    }
    
    private func getNotificationCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
        return configureNotificationCell(cell)
    }
    
    private func configureNotificationCell( _ cell: SwitchCell) -> SwitchCell {
        cell.cellSwitch.onTintColor = color
        cell.cellSwitch.isOn = subscriptionNotificationable
        cell.isSetBottomLine = true
        cell.cellTitleLabel.text = NSLocalizedString("notify", comment: "")
        cell.onValueChange = { switchElement in
            self.subscriptionNotificationable = switchElement.isOn
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
        let defaultValueIndexComponent1 = (cell.pickerViewDataItems[1] as! [PeriodType]).firstIndex(of: subscriptionPaymentPeriod.1)
        cell.pickerView.selectRow(subscriptionPaymentPeriod.0 - 1, inComponent: 0, animated: false)
        cell.pickerView.selectRow(defaultValueIndexComponent1!, inComponent: 1, animated: false)
        cell.cellValueTextField.text = "\(NSLocalizedString("every", comment: "")) \(self.subscriptionPaymentPeriod.0) \(self.subscriptionPaymentPeriod.1.getLocaleTitle())"
        cell.onValueChange = { pickerView in
            let selectedNumber = cell.pickerViewDataItems[0][pickerView.selectedRow(inComponent: 0)] as! Int
            let selectedPeriodType = cell.pickerViewDataItems[1][pickerView.selectedRow(inComponent: 1)] as! PeriodType
            self.subscriptionPaymentPeriod = (selectedNumber, selectedPeriodType)
            cell.cellValueTextField.text = "\(NSLocalizedString("every", comment: "")) \(self.subscriptionPaymentPeriod.0) \(self.subscriptionPaymentPeriod.1.getLocaleTitle())"
        }
        cell.doneToolbarButtonColor = color
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
        cell.doneToolbarButtonColor = color
        cell.datePicker.date = subscriptionNextPaymentDate
        cell.cellValueTextField.text = getDateLocaleFormat(subscriptionNextPaymentDate)
        cell.onValueChange = { pickerView in
            self.subscriptionNextPaymentDate = pickerView.date
            cell.cellValueTextField.text = getDateLocaleFormat(self.subscriptionNextPaymentDate)
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
        cell.pickerViewDataItems = [currencies]
        cell.titleForRowInDataItems = { _, row in
            let resultString = "\((cell.pickerViewDataItems[0][row] as! CurrencyProtocol).title) (\((cell.pickerViewDataItems[0][row] as! CurrencyProtocol).symbol))"
            return resultString
        }
        cell.isSetBottomLine = true
        let indexOfDefaultValue = currencies.firstIndex(where: {$0.identifier == subscriptionCurrency.identifier})!
        cell.pickerView.selectRow(Int(indexOfDefaultValue), inComponent: 0, animated: false)
        cell.cellValueTextField.text = "\(subscriptionCurrency.title) (\(subscriptionCurrency.symbol))"
        cell.doneToolbarButtonColor = color
        cell.onValueChange = { pickerView in
            self.subscriptionCurrency = cell.pickerViewDataItems[0][pickerView.selectedRow(inComponent: 0)] as? CurrencyProtocol
            cell.cellValueTextField.text = "\(self.subscriptionCurrency.title) (\(self.subscriptionCurrency.symbol))"
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
        cell.cellValueTextField.text = getAmountFormattedString(String(subscriptionAmount))
        cell.cellValueTextField.keyboardType = .numberPad
        cell.cellValueTextField.addTarget(nil, action: #selector(amountTextFieldValueDidChanged(_:)), for: .editingChanged)
        cell.isSetBottomLine = true
        cell.doneToolbarButtonColor = color
        return cell
    }
    
    @objc func amountTextFieldValueDidChanged(_ textField: UITextField) {
        guard let textFieldValue = textField.text else {
            return
        }
        textField.text = getAmountFormattedString(textFieldValue)
        subscriptionAmount = Float(textField.text!)!
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
                self.subscriptionDescription = ""
                return
            }
            self.subscriptionDescription = textNotice
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

extension AddSubscriptionController: Receiver {
    func receive(signal: Signal) -> Signal? {
        if case CurrencySignal.currencies(let currenciesList) = signal {
            currencies = currenciesList
        }
        return nil
    }
}
