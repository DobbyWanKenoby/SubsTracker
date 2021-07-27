import UIKit
import SwiftCoordinatorsKit

protocol ServicesListControllerProtocol: Receiver where Self: UIViewController {
    // Input Data
    var services: [ServiceProtocol] { get set }
    
    // Output callbacks
    var onSelectService: ((ServiceProtocol, UITableViewCell) -> Void)? { get set }
    
    // Helpers
    func getSelectedCell() -> UITableViewCell?
}

class ServicesListController: UIViewController, ServicesListControllerProtocol, StoryboardBasedViewController {
    var viewControllerIdentifier: String = "ServicesListController"
    var storyboardFileName: String = "ServicesListController"
    
    @IBOutlet var tableView: UITableView!

    var services: [ServiceProtocol] = []
    var onSelectService: ((ServiceProtocol, UITableViewCell) -> Void)?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "STServiceCell", bundle: nil), forCellReuseIdentifier: "STServiceCell")
        configureView()
        tableView.clipsToBounds = false
    }
    
    private func configureView() {
        self.navigationItem.title = NSLocalizedString("new_subscription", comment: "")
        self.navigationItem.largeTitleDisplayMode = .always
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView()
    }
    
    func getSelectedCell() -> UITableViewCell? {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return nil
        }
        return self.tableView.cellForRow(at: indexPath)
    }

}

// MARK: - Table View Data Source

extension ServicesListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return services.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return getCellForCustomService(indexPath, tableView)
        } else {
            return getCellForService(indexPath, tableView)
        }
    }
    
    private func getCellForCustomService(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "STServiceCell") as! STServiceCell
        //cell.logoImageView.image = currentService.logo
        cell.titleLabel.text = NSLocalizedString("new service", comment: "")
        cell.contentView.backgroundColor = .systemGray2
        cell.selectionStyle = .none
        return cell
    }
    
    private func getCellForService(_ indexPath: IndexPath, _ tableView: UITableView) -> UITableViewCell {
        let currentService = services[indexPath.section-1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "STServiceCell") as! STServiceCell
        cell.logoImageView.image = currentService.logo
        cell.titleLabel.text = currentService.title
        cell.contentView.backgroundColor = currentService.color
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Table View Delegate

extension ServicesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let selectedService = services[indexPath.section-1]
        onSelectService?(selectedService, selectedCell)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension ServicesListController: Receiver {
    func receive(signal: Signal) -> Signal? {
        if case ServiceSignal.services(let servicesList) = signal {
            services = servicesList
        }
        return nil
    }
}
