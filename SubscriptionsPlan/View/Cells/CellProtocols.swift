//
//  Protocols.swift
//  SubscriptionsPlan
//
//  Created by Admin on 02.07.2021.
//

import UIKit

// MARK: - Cell

protocol STCellProtocol: UITableViewCell {}

// Ячейка, предназначенная для ввода каких-либо данных
protocol STInputCellProtocol: STCellProtocol {
    var onSelectAnyCellElement: (() -> Void)? { get set }
}

// Ячейка, предназначенная для отображения каких-либо данных
protocol STViewCellProtocol: STCellProtocol {}
