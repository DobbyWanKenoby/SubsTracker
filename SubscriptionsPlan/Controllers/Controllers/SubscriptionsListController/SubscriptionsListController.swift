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
    var onSelectSubscription: ((SubscriptionProtocol) -> Void)? { get set }
}

class SubscriptionsListController: UITableViewController, SubscriptionsListControllerProtocol {
    
    var onSelectSubscription: ((SubscriptionProtocol) -> Void)?
    
    var subscriptions: [SubscriptionProtocol]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var sortedSubscriptions: [SubscriptionProtocol] {
        let s = subscriptions.sorted{ $0.nextPayment.1 < $1.nextPayment.1 }
        return s
    }
    
    var sortType: SubscriptionSortType = .time

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellReuseIdentifier: "SubscriptionCell")
        configureView()
    }
    
    private func configureView() {
        self.navigationItem.title = NSLocalizedString("subscriptions", comment: "")
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
        cell.priceLabel.text = "\(currentSubscription.currency.symbol) \(currentSubscription.amount)"
        cell.timeRemain.text = timeRemainText(toRemainDays: currentSubscription.nextPayment.daysRemain)
        cell.descriptionLabel.text = currentSubscription.description
        return cell
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
        let deleteAction = UIContextualAction(style: .normal, title: "") {_,_,_ in
            
        }
        deleteAction.backgroundColor = UIColor.systemBackground
        let configurator = UIImage.SymbolConfiguration(pointSize: 40)
        deleteAction.image = UIImage(systemName: "trash.circle.fill", withConfiguration: configurator)!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        let editAction = UIContextualAction(style: .normal, title: "") {[unowned self] _,_,complete in
            self.onSelectSubscription?(sortedSubscriptions[indexPath.row])
            complete(true)
        }
        editAction.backgroundColor = UIColor.systemBackground
        let color = sortedSubscriptions[indexPath.row].service.color
        editAction.image = UIImage(systemName: "pencil.circle.fill", withConfiguration: configurator)!.withTintColor(color, renderingMode: .alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
//            return
//        }
        onSelectSubscription?(sortedSubscriptions[indexPath.row])
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
}
