//
//  InitializatorController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 23.05.2021.
//

import UIKit

protocol InitializatorControllerProtocol where Self: UIViewController {
    var initializationDidEnd: (() -> Void)? { get set }
}

class InitializatorController: UIViewController, InitializatorControllerProtocol {

    var initializationDidEnd: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        initializationDidEnd?()
    }
}
