//
//  Main.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 01.01.2021.
//

import UIKit

class UpcomingViewController: UITableViewController, StoryboardBasedViewController, UpcomingTransferInterface {
    var viewControllerIdentifier: String  = "Upcoming"
    var storyboardFileName: String  = "Upcoming"
    
    var inputData: UpcomingControllerInputDataElements! {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SubscriptionCell", bundle: nil), forCellReuseIdentifier: "SubscriptionCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputData.subscriptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSubscription = inputData.subscriptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as! SubscriptionCell
        cell.baseColorView.backgroundColor = currentSubscription.service.color
        cell.titleLabel.text = currentSubscription.service.title
        return cell
    }
}
