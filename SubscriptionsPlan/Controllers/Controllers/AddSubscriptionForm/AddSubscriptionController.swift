//
//  AddSubOverlayView.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

// Определят тип отображения контроллера
// В разных ситуациях он может включать разные данные
// и отображаться различным способом
enum AddSubscriptionControllerDisplayType {
    case createSubOfExistService
    case createSubAndService
    case editSubscription
}

protocol AddSubscriptionControllerProtocol: Receiver where Self: UIViewController {
    // Input Data
    var subscription: SubscriptionProtocol? { get set }
    var service: ServiceProtocol? { get set }
    var currencies: [CurrencyProtocol]! { get set }
    // Устанавливает переключатель валюты в указанное значение
    var currentCurrency: CurrencyProtocol! { get set }
    
    // Output Callbacks
    var onCancelScene: ((SubscriptionProtocol?) -> Void)? { get set }
    var onSaveSubscription: ((_ subscription: SubscriptionProtocol, _ isNewService: Bool) -> Void)? { get set }
    
    // Helpers
    var displayType: AddSubscriptionControllerDisplayType { get set }
}

class AddSubscriptionController: UIViewController, AddSubscriptionControllerProtocol {

    // MARK: Input Data
    var subscription: SubscriptionProtocol? {
        get { self._subscription }
        set {
            _subscription = newValue
            guard let sub = newValue else {
                return
            }
            
            subscriptionAmount = sub.amount
            subscriptionDescription = sub.description
            subscriptionNextPaymentDate = sub.nextPayment.date
            subscriptionPaymentPeriod = sub.paymentPeriod
            subscriptionNotificationable = sub.isNotificationable
            subscriptionNotificationDaysPeriod = sub.notificationDaysPeriod
        }
    }
    private var _subscription: SubscriptionProtocol?
    var service: ServiceProtocol? {
        get { self._service }
        set {
            _service = newValue
            guard let ser = _service else {
                return
            }
            
            serviceLogo = ser.logo
            serviceTitle = ser.title
        }
    }
    private var _service: ServiceProtocol?
    var currencies: [CurrencyProtocol]!
    var currentCurrency: CurrencyProtocol! {
        get { self._currentCurrency }
        set {
            _currentCurrency = newValue
            subscriptionCurrency = newValue
        }
    }
    private var _currentCurrency: CurrencyProtocol!
    
    lazy var firstCellHeight: CGFloat = {
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 0))!.frame.height
    }()
    
    
    var displayType: AddSubscriptionControllerDisplayType = .createSubOfExistService
    
    // MARK: Output Callbacks
    var onCancelScene: ((SubscriptionProtocol?) -> Void)?
    var onSaveSubscription: ((_ subscription: SubscriptionProtocol, _ isNewService: Bool) -> Void)?
    
    // MARK: Helpers
    // используется для корретного изменения инсетов таблицы
    // при открытии клавиатуры
    private var selectedCell: UITableViewCell!
    
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
    private lazy var headerBaseHeight: CGFloat = {
        150
    }()
    // дефолтный отступ tableView
    // используется, чтобы кнопки не перекрывали все элементы таблицы
    // а так же, чтобы сверху
    private lazy var tableViewDefaultInset: UIEdgeInsets = {
        // стандартный инсет под кнопки
        let buttonsInsetBottom: CGFloat = 50
        let inset: UIEdgeInsets
        switch self.displayType {
        case .createSubOfExistService:
            inset = UIEdgeInsets(top: 140,
                                     left: 0,
                                     bottom: buttonsInsetBottom + SafeArea.inset.bottom,
                                     right: 0)
            return inset
        case .createSubAndService:
            inset = UIEdgeInsets(top: 140,
                                     left: 0,
                                     bottom: buttonsInsetBottom + SafeArea.inset.bottom,
                                     right: 0)
            return inset
        case .editSubscription:
            inset = UIEdgeInsets(top: 0,
                                     left: 0,
                                     bottom: buttonsInsetBottom + SafeArea.inset.bottom,
                                     right: 0)
        }
        return inset
    }()
    
    // редактируемые данные
    // далее они будут использованы для создания/обновления подписки
    //  данные о картинке будут записаны, только если создается подписка
    var serviceLogo: UIImage?
    var serviceTitle: String?
    var subscriptionNotificationDaysPeriod: Int = 1
    var subscriptionNotificationable: Bool = true
    var subscriptionPaymentPeriod: (Int, PeriodType) = (1, .month)
    var subscriptionNextPaymentDate = Date()
    var subscriptionDescription: String = ""
    var subscriptionCurrency: CurrencyProtocol!
    var subscriptionAmount: Float = 0
    
    lazy var cellFactory: CellFactory = {
        CellFactory(forTableView: self.tableView)
    }()
    
    // MARK: Outlets
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var serviceView: UIView!
    @IBOutlet var serviceLogoView: UIImageView!
    @IBOutlet var serviceTitleLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellFactory()
        addKeyboardObserver()
        print(subscriptionNextPaymentDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureButtons()
        configureTableView()
        self.tableView.reloadData()
    }
    
    //MARK: Configuration Scene
    
    private func configureTableView() {
        tableView.contentInset = tableViewDefaultInset
    }
    
    private func addKeyboardObserver() {
        // появление клавиатуры
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // скрытие клавиатуры
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
    
    private func setupCellFactory(){
        cellFactory.registerCell(type: .picker)
        cellFactory.registerCell(type: .textField)
        cellFactory.registerCell(type: .date)
        cellFactory.registerCell(type: .switch)
        cellFactory.registerCell(type: .service)
    }
    
    // отодвигаем текстовое поле, чтобы его было видно над клавиатурой
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = tableViewDefaultInset
    }
    
    // отодвигаем текстовое поле, чтобы его было видно над клавиатурой
    @objc func keyboardWillShow(_ notification: Notification) {
        if selectedCell == nil {
            return
        }
        let bottomYCoordinate = (selectedCell.contentView.superview?.convert(selectedCell.contentView.frame.origin, to: nil).y)! + selectedCell.frame.height

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableView.contentInset.bottom = keyboardHeight
            let screenHeight = UIScreen.main.bounds.size.height
            if screenHeight - keyboardHeight < bottomYCoordinate + 80 {
                let offset = keyboardHeight - (screenHeight - bottomYCoordinate) + 150
                tableView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
            }
        }
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
        onCancelScene?(subscription)
    }
    
    @IBAction func dismissControllerWithSuccess() {
        if subscriptionAmount == 0 {
            let alert = UIAlertController(title: NSLocalizedString("attention", comment: ""), message: NSLocalizedString("you must set amount", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "").uppercased(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let newSubscription = getSubscriptionObject()
            onSaveSubscription?(newSubscription, false)
        }
    }
    
    fileprivate func getSubscriptionObject() -> SubscriptionProtocol {
        let subscriptionService = service ?? Service(identifier: UUID().uuidString, title: "empty", colorHEX: "#fff")
        let newSubscription = Subscription(identifier: subscription?.identifier ?? UUID(),
                                        service: subscriptionService,
                                        amount: subscriptionAmount,
                                        currency: subscriptionCurrency,
                                        description: subscriptionDescription,
                                        nextPaymentDate: subscriptionNextPaymentDate,
                                        paymentPeriod: subscriptionPaymentPeriod,
                                        isNotificationable: subscriptionNotificationable,
                                        notificationDaysPeriod: subscriptionNotificationDaysPeriod)
        return newSubscription
    }
}

// MARK: - Table View Data Source

extension AddSubscriptionController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayType == .editSubscription {
            return 8
        } else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if displayType == .editSubscription && indexPath.row == 0 {
            return 130
        } else {
            return UITableView().estimatedRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if displayType == .editSubscription {
            cell = getCell_subscriptionUpdate(indexPath: indexPath)
        } else {
            cell = getCell_subscriptionCreate_ServiceExist(indexPath: indexPath)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // возвращает ячейку в случае, когда подписка создается на основе существующего сервиса
    private func getCell_subscriptionUpdate(indexPath: IndexPath) -> UITableViewCell {
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
    
    // возвращает ячейку в случае, когда подписка создается на основе существующего сервиса
    private func getCell_subscriptionCreate_ServiceExist(indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch (indexPath.row) {
        case 0:
            cell = getAmounCell()
        case 1:
            cell = getCurrencyCell()
        case 2:
            cell = getDateCell()
        case 3:
            cell = getPeriodCell()
        case 4:
            cell = getNoticeCell()
        case 5:
            cell = getNotificationCell()
        case 6:
            cell = getNotificationPeriodCell()
        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            break
        }
        return cell
    }
    
    private func getServiceCell() -> UITableViewCell {
        let cell = cellFactory.getServiceCell(serviceTitle: serviceTitle ?? "", color: color, logo: serviceLogo)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "STServiceCell") as! STServiceCell
//        if displayType == .inNavigationController {
//            cell.contentView.layer.cornerRadius = 0
//        }
//        cell.logoImageView.image = serviceLogo
//        cell.titleLabel.text = serviceTitle
//        cell.contentView.backgroundColor = color
        return cell
    }
    
    private func getNotificationPeriodCell() -> UITableViewCell {
        // данные для отображения в picker
        var selectedRows = [0,0,0]
        
        let inSection: [(pickerRowTitle: String, instance: Any)] = [(NSLocalizedString("in (notify)", comment: ""), "")]
        var numbersPicker: [(pickerRowTitle: String, instance: Any)] = []
        for (index, i) in Array(1...30).enumerated() {
            numbersPicker.append((String(i),i))
            if i == subscriptionNotificationDaysPeriod{
                selectedRows[0] = index
            }
        }
        let daysSection: [(pickerRowTitle: String, instance: Any)] = [(NSLocalizedString("day(s)", comment: ""), "")]
        
        let cell = cellFactory.getPickerCell(title: NSLocalizedString("payment period", comment: ""),
                                         pickerViewData: [inSection, numbersPicker, daysSection],
                                         selectedRowsInSections: selectedRows)
        cell.didValueChanged = { [unowned self] pickerView in
            self.subscriptionNotificationDaysPeriod = numbersPicker[pickerView.selectedRow(inComponent: 1)].instance as! Int
        }
        cell.textForLabelWhenPickerValueChanged = { pickerView in
            let selectedNumber = numbersPicker[pickerView.selectedRow(inComponent: 1)].instance as! Int
            return String(format: NSLocalizedString("in %d days (notify)", comment: ""), selectedNumber)
        }
        cell.accentColor = color
        cell.onSelectAnyCellElement = { [weak self] in
            self?.selectedCell = cell
        }
        return cell
    }
    
    private func getNotificationCell() -> UITableViewCell {
        let cell = cellFactory.getSwitchCell(title: NSLocalizedString("notify", comment: ""), isActivate: subscriptionNotificationable)
        cell.accentColor = color
        cell.didValueChanged = { [unowned self] switcher in
            self.subscriptionNotificationable = switcher.isOn
        }
        
        return cell
    }
    
    private func getPeriodCell() -> UITableViewCell {
        // данные для отображения в picker
        var selectedRows = [0,0]
        
        var numbersForPicker: [(pickerRowTitle: String, instance: Any)] = []
        for (index, i) in Array(1...30).enumerated() {
            numbersForPicker.append((String(i),i))
            if i == subscriptionPaymentPeriod.0 {
                selectedRows[0] = index
            }
        }
        
        var periodsForPicker: [(pickerRowTitle: String, instance: Any)] = []
        for (index, period) in PeriodType.allCases.enumerated() {
            periodsForPicker.append((period.rawValue, period))
            if period == subscriptionPaymentPeriod.1 {
                selectedRows[1] = index
            }
        }
        
        
        let cell = cellFactory.getPickerCell(title: NSLocalizedString("payment period", comment: ""),
                                         pickerViewData: [numbersForPicker, periodsForPicker],
                                         selectedRowsInSections: selectedRows)
        cell.didValueChanged = { [unowned self] pickerView in
            let selectedNumber = numbersForPicker[pickerView.selectedRow(inComponent: 0)].instance as! Int
            let selectedPeriodType = periodsForPicker[pickerView.selectedRow(inComponent: 1)].instance as! PeriodType
            self.subscriptionPaymentPeriod = (selectedNumber, selectedPeriodType)
        }
        cell.textForLabelWhenPickerValueChanged = { pickerView in
            let selectedNumber = numbersForPicker[pickerView.selectedRow(inComponent: 0)].instance as! Int
            let selectedPeriodType = periodsForPicker[pickerView.selectedRow(inComponent: 1)].instance as! PeriodType
            return "\(NSLocalizedString("every", comment: "")) \(selectedNumber) \(selectedPeriodType.getLocaleTitle().lowercased())"
            
        }
        cell.accentColor = color
        cell.onSelectAnyCellElement = { [weak self] in
            self?.selectedCell = cell
        }
        return cell
    }
    
    private func getDateCell() -> UITableViewCell {
        let cell: STDatePickerCellProtocol
        if subscription == nil {
            cell = cellFactory.getDatePickerCell(title: NSLocalizedString("first payment", comment: ""),
                                                     selectedDate: subscriptionNextPaymentDate)
        } else {
            cell = cellFactory.getDatePickerCell(title: NSLocalizedString("next_payment", comment: ""),
                                                     selectedDate: subscriptionNextPaymentDate)
        }
        
        cell.didDateChanged = { [weak self] date in
            print(date)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            //dateFormatter.da
            self!.subscriptionNextPaymentDate = date
        }
        cell.accentColor = color
        cell.onSelectAnyCellElement = { [weak self] in
            self?.selectedCell = cell
        }
        
        return cell
    }
    
    private func getCurrencyCell() -> UITableViewCell {
        // данные для отображения в picker
        var currencyDataForPicker: [(pickerRowTitle: String, instance: Any)] = []
        var selectedRow = 0
        for (index, currency) in currencies.enumerated() {
            let title = "\(currency.title) (\(currency.symbol))"
            currencyDataForPicker.append((pickerRowTitle: title, instance: currency))
            if subscriptionCurrency.identifier == currency.identifier {
                selectedRow = index
            }
        }
        
        let cell = cellFactory.getPickerCell(title: NSLocalizedString("currency", comment: ""),
                                         pickerViewData: [currencyDataForPicker],
                                         selectedRowsInSections: [selectedRow])
        cell.didValueChanged = { [weak self] pickerView in
            self?.subscriptionCurrency = cell.pickerViewData[0][pickerView.selectedRow(inComponent: 0)].instance as? CurrencyProtocol
        }
        cell.textForLabelWhenPickerValueChanged = { pickerView in
            return currencyDataForPicker[pickerView.selectedRow(inComponent: 0)].pickerRowTitle
        }
        cell.accentColor = color
        
        cell.onSelectAnyCellElement = { [weak self] in
            self?.selectedCell = cell
        }
        
        setAccessibilities(cell, with: .cellCurrency)
        return cell
    }
    
    private func getAmounCell() -> UITableViewCell {
        let cell = cellFactory.getTextFieldCell(title: NSLocalizedString("amount", comment: ""),
                                                text: getAmountFormattedString(String(subscriptionAmount)))
        cell.textField.placeholder = "0.00"
        cell.textField.keyboardType = .decimalPad
        
        cell.accentColor = color
        cell.didValueChanged = { [unowned self] textField in
            let amount = self.getAmountFormattedString(textField.text ?? "")
            textField.text = amount
            self.subscriptionAmount = Float(amount) ?? 0
        }
        if subscription == nil {
            cell.value = ""
        }
        cell.onSelectAnyCellElement = { [weak self] in
            self?.selectedCell = cell
        }
        
        // хак, чтобы корректно менять инсеты при появлении клавиатуры
        //(cell as? STTextFieldCell)?.textField.addTarget(self, action: #selector(selectCell), for: .editingDidBegin)
        setAccessibilities(cell, with: .cellAmount)
        return cell
    }
    
//    @objc private func selectCell() {
//
//        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
//    }
    
    private func getAmountFormattedString(_ value: String) -> String {
        var resultText = ""
        let correctValue = value.replacingOccurrences(of: ",", with: ".")
        let valueSections = value.split(separator: ".")
        if valueSections.count == 1 && correctValue.first(where: { $0 == "." }) != nil {
            resultText = "\(String(valueSections.first!))."
            return resultText
        }
        
        for (index, section) in valueSections.enumerated() {
            if index == 0 {
                resultText = "\(section)"
            } else if index == 1 {
                var _section = section
                while _section.count > 2 {
                    _section.removeLast()
                }
                resultText += ".\(_section)"
            } else if index > 1 {
                break
            }
        }

        return resultText
    }
    
    private func getNoticeCell() -> UITableViewCell {
        let cell = cellFactory.getTextFieldCell(title: NSLocalizedString("notice", comment: ""),
                                                text: subscriptionDescription)
        cell.textField.placeholder = ""
        cell.textField.keyboardType = .alphabet
        cell.accentColor = color
        cell.didValueChanged = { [unowned self] textField in
            self.subscriptionDescription = textField.text ?? ""
        }
        if subscription == nil {
            cell.value = ""
        }
        return cell
    }
}

// MARK: - Table View Delegate

extension AddSubscriptionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedCell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.cellForRow(at: indexPath)?.viewWithTag(1)?.becomeFirstResponder()
    }
}

//// MARK: - Text Field Delegate
//
//extension AddSubscriptionController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.editingTextField = textField
//    }
//}
