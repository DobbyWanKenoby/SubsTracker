import UIKit

protocol ServicesListControllerProtocol where Self: UIViewController {
    var services: [ServiceProtocol] { get set }
    var onSelectService: ((ServiceProtocol, UITableViewCell) -> Void)? { get set }
}

class ServicesListController: UITableViewController, ServicesListControllerProtocol {

    var services: [ServiceProtocol] = []
    var onSelectService: ((ServiceProtocol, UITableViewCell) -> Void)?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        configureView()
    }
    
    private func configureView() {
        self.navigationItem.title = "Новая подписка"
        self.navigationItem.largeTitleDisplayMode = .always
        self.tableView.separatorStyle = .none
    }

}

// MARK: - Table View Data Source

extension ServicesListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentService = services[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as! ServiceCell
        cell.logoImageView.image = currentService.logo
        cell.titleLabel.text = currentService.title
        cell.baseColorView.backgroundColor = currentService.color
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Table View Delegate

extension ServicesListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let selectedService = services[indexPath.row]
        onSelectService?(selectedService, selectedCell)
    }
}
