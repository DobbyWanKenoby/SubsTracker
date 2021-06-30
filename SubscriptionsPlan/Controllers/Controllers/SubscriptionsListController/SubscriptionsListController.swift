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
            text = String(format: NSLocalizedString("in %d weeks", comment: ""), 1)
        case _ where days >= 11 && days < 17 :
            text = String(format: NSLocalizedString("in %d weeks", comment: ""), 2)
        case _ where days >= 18 && days < 23 :
            text = String(format: NSLocalizedString("in %d weeks", comment: ""), 3)
        case _ where days >= 24 && days < 29 :
            text = String(format: NSLocalizedString("in %d weeks", comment: ""), 4)
        case _ where days >= 30 && days < 45 :
            text = String(format: NSLocalizedString("in %d months", comment: ""), 1)
        case _ where days >= 46 && days < 70 :
            text = String(format: NSLocalizedString("in %d months", comment: ""), 2)
        case _ where days >= 71 && days < 300 :
            text = String(format: NSLocalizedString("in %d months", comment: ""), days/30)
        case _ where days >= 301 && days < 380 :
            text = String(format: NSLocalizedString("in %d years", comment: ""), 1)
        case _ where days >= 381 :
            text = String(format: NSLocalizedString("in %d years", comment: ""), days/365)
        default:
            text = String(format: NSLocalizedString("in %d days", comment: ""), days)
        }
        
        return text
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
