//
//  Main.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 01.01.2021.
//

import UIKit

enum SubscriptionSortType {
    case time
}

protocol SubscriptionsListControllerProtocol: UIViewController {
    
    var subscriptions: [SubscriptionProtocol]! { get set }
    var sortType: SubscriptionSortType { get set }
    
    // Output callbacks
    var onActivateEditSubscription: ((SubscriptionProtocol) -> Void)? { get set }
    // При нажатии кнопки удаления подписки
    var onPressDeleteSubscription: ((SubscriptionProtocol) -> Void)? { get set }
    func doAfterDelete(subscription: SubscriptionProtocol) -> Void
    // При нажатии кнопки подтверждения оплаты по подписке
    var onSuccessNextPayment: ((SubscriptionProtocol) -> Void)? { get set }
    // var onDeleteSubscription: ((SubscriptionProtocol) -> Void)? { get set }
    
    
}

class SubscriptionsListController: UITableViewController, SubscriptionsListControllerProtocol {
    
    var onActivateEditSubscription: ((SubscriptionProtocol) -> Void)?
    var onPressDeleteSubscription: ((SubscriptionProtocol) -> Void)?
    var onSuccessNextPayment: ((SubscriptionProtocol) -> Void)?
    
    var subscriptions: [SubscriptionProtocol]! {
        didSet {
            if _needUpdateRows {
                tableView.reloadData()
            }
        }
    }
    // флаг определяет нужно ли обновлять всю таблицу после изменения данных в свойстве subscriptions
    private var _needUpdateRows: Bool = true
    
    var sortedSubscriptions: [SubscriptionProtocol] {
        let s = subscriptions.sorted{ $0.nextPayment.1 < $1.nextPayment.1 }
        return s
    }
    
    var sortType: SubscriptionSortType = .time
    
    func doAfterDelete(subscription deletedSubscription: SubscriptionProtocol) -> Void {
        for (index, subscription) in subscriptions.enumerated() {
            if subscription.identifier == deletedSubscription.identifier {
                _needUpdateRows.toggle()
                subscriptions.remove(at: index)
                _needUpdateRows.toggle()
                tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellReuseIdentifier: "SubscriptionCell")
        configureView()
    }
    
    private func configureView() {
        self.navigationItem.title = NSLocalizedString("payments", comment: "")
        self.navigationItem.largeTitleDisplayMode = .always
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedSubscriptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSubscription = sortedSubscriptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as! SubscriptionCell
        cell.baseColorView.backgroundColor = currentSubscription.service.color
        cell.headerView.backgroundColor = currentSubscription.service.color
        cell.titleLabel.text = currentSubscription.service.title
        cell.logoImageView.image = currentSubscription.service.logo
        //cell.priceLabel.text = "\(currentSubscription.currency.symbol) \(currentSubscription.amount)"
        cell.priceLabel.text = getFormattedLocalPrice(symbol: currentSubscription.currency.symbol, amount: currentSubscription.amount)
        cell.timeRemain.text = timeRemainText(toRemainDays: currentSubscription.nextPayment.daysRemain)
        cell.descriptionLabel.text = currentSubscription.description
        return cell
    }
    
    private func getFormattedLocalPrice(symbol: String, amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = symbol
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? ""
    }
    
    private func timeRemainText(toRemainDays days: Int) -> String {
        let text: String
        switch days {
        case 0:
            text = NSLocalizedString("today", comment: "")
        case 1:
            text = NSLocalizedString("tomorrow", comment: "")
        case 2:
            text = NSLocalizedString("day after tomorrow", comment: "")
        case _ where days > 5 && days < 10 :
            text = String(format: NSLocalizedString("in %d weeks (pay)", comment: ""), 1)
        case _ where days >= 11 && days < 17 :
            text = String(format: NSLocalizedString("in %d weeks (pay)", comment: ""), 2)
        case _ where days >= 18 && days < 23 :
            text = String(format: NSLocalizedString("in %d weeks (pay)", comment: ""), 3)
        case _ where days >= 24 && days < 29 :
            text = String(format: NSLocalizedString("in %d weeks (pay)", comment: ""), 4)
        case _ where days >= 30 && days < 45 :
            text = String(format: NSLocalizedString("in %d months (pay)", comment: ""), 1)
        case _ where days >= 46 && days < 70 :
            text = String(format: NSLocalizedString("in %d months (pay)", comment: ""), 2)
        case _ where days >= 71 && days < 300 :
            text = String(format: NSLocalizedString("in %d months (pay)", comment: ""), days/30)
        case _ where days >= 301 && days < 380 :
            text = String(format: NSLocalizedString("in %d years (pay)", comment: ""), 1)
        case _ where days >= 381 :
            text = String(format: NSLocalizedString("in %d years (pay)", comment: ""), days/365)
        default:
            text = String(format: NSLocalizedString("in %d days (pay)", comment: ""), days)
        }
        
        return text
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { [unowned self]_,_,complete in
            onPressDeleteSubscription?(sortedSubscriptions[indexPath.row])
            complete(true)
        }
        deleteAction.backgroundColor = UIColor.systemBackground
        let configurator = UIImage.SymbolConfiguration(pointSize: 40)
        deleteAction.image = UIImage(systemName: "trash.circle.fill", withConfiguration: configurator)!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        let editAction = UIContextualAction(style: .normal, title: "") {[unowned self] _,_,complete in
            onActivateEditSubscription?(sortedSubscriptions[indexPath.row])
            complete(true)
        }
        editAction.backgroundColor = UIColor.systemBackground
        let color = sortedSubscriptions[indexPath.row].service.color
        editAction.image = UIImage(systemName: "pencil.circle.fill", withConfiguration: configurator)!.withTintColor(color, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let configurator = UIImage.SymbolConfiguration(pointSize: 40)
        let successPaymentAction = UIContextualAction(style: .normal, title: "") {[unowned self] _,_,complete in
            self.onSuccessNextPayment?(sortedSubscriptions[indexPath.row])

            complete(true)
        }
        successPaymentAction.backgroundColor = UIColor.systemBackground
        let color = sortedSubscriptions[indexPath.row].service.color
        successPaymentAction.image = UIImage(systemName: "arrow.counterclockwise.circle.fill", withConfiguration: configurator)!.withTintColor(color, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [successPaymentAction])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
//            return
//        }
        onActivateEditSubscription?(sortedSubscriptions[indexPath.row])
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
}
