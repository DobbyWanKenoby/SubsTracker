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
}

class CellFactory {
    
    private var tableView: UITableView
    
    init(forTableView tableView: UITableView) {
        self.tableView = tableView
    }
    
    func registerCell(type: CellType) {
        switch type {
        case .picker:
            //tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
            tableView.register(STPickerCell.self, forCellReuseIdentifier: type.rawValue)
        case .textField:
            tableView.register(UINib(nibName: type.rawValue, bundle: nil), forCellReuseIdentifier: type.rawValue)
        }
    }
    
    func getPickerCell(title: String, pickerViewData: [PickerComponentData], selectedRowsInSections: [Int]) -> STPickerCellProtocol {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.picker.rawValue) as? STPickerCellProtocol else {
//            return STPickerCell(title: title, pickerViewData: pickerViewData, selectedRowsInSections: selectedRowsInSections, accentColor: accentColor, reuseIdentifier: CellType.picker.rawValue)
//        }
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
    
}
