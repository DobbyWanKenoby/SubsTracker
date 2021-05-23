import UIKit

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
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        configureView()
        tableView.clipsToBounds = false
    }
    
    private func configureView() {
        self.navigationItem.title = "Новая подписка"
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
        return services.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentService = services[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        cell.logoImageView.image = currentService.logo
        cell.titleLabel.text = currentService.title
        cell.contentView.backgroundColor = currentService.color
        cell.selectionStyle = .none
//        cell.contentView.layer.shadowOpacity = 0.5
//        cell.contentView.layer.shadowColor = UIColor.black.cgColor
//        cell.contentView.layer.shadowRadius = 5
//        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        cell.contentView.clipsToBounds = false
        return cell
    }
}

// MARK: - Table View Delegate

extension ServicesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let selectedService = services[indexPath.section]
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
        if case ServiceSignal.actualServices(let servicesList) = signal {
            services = servicesList
        }
        return nil
    }
}
