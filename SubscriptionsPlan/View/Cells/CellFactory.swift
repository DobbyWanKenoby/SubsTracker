//
//  CellFactory.swift
//  SubscriptionsPlan
//
//  Created by Admin on 02.07.2021.
//

import UIKit

enum CellType: String {
    case picker = "STPickerCell"
    case textField = "STTextFieldCell"
    case date = "STDatePickerCell"
    case `switch` = "STSwitchCell"
    case service = "STServiceCell"
}

class CellFactory {
    
    private var tableView: UITableView
    
    init(forTableView tableView: UITableView) {
        self.tableView = tableView
    }
    
    func registerCell(type: CellType) {
        switch type {
        case .picker:
            tableView.register(STPickerCell.self, forCellReuseIdentifier: type.rawValue)
        case .textField:
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        case .date:
            tableView.register(STDatePickerCell.self, forCellReuseIdentifier: type.rawValue)
        case .switch:
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        case .service:
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        }
    }
    
    func getServiceCell(serviceTitle: String, color: UIColor, logo: UIImage?) -> STServiceCellProtocol{
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.service.rawValue) as! STServiceCellProtocol
        cell.title = serviceTitle
        cell.logo = logo
        cell.accentColor = color
        return cell
    }
    
    func getPickerCell(title: String, pickerViewData: [PickerComponentData], selectedRowsInSections: [Int]) -> STPickerCellProtocol {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.picker.rawValue) as! STPickerCellProtocol
        cell.title = title
        cell.pickerViewData = pickerViewData
        cell.selectedRows = selectedRowsInSections
        return cell
    }
    
    func getTextFieldCell(title: String, text: String) -> STTextFieldCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.textField.rawValue) as! STTextFieldCell
        cell.titleLabel.text = title
        cell.textField.text = text
        return cell
    }
    
    func getDatePickerCell( title: String, selectedDate: Date ) -> STDatePickerCellProtocol {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.date.rawValue) as! STDatePickerCellProtocol
        cell.title = title
        cell.selectedDate = selectedDate
        return cell
    }
    
    func getSwitchCell(title: String, isActivate: Bool) -> STSwitchCellProtocol {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.switch.rawValue) as! STSwitchCellProtocol
        cell.title = title
        cell.isActivate = isActivate
        return cell
    }
    
}
