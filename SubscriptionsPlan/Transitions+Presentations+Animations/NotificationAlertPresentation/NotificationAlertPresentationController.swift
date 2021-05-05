//
//  OverlayPresenterController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

class NotificationAlertPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let point = CGPoint(x: UIScreen.main.bounds.width / 2 - 100, y: UIScreen.main.bounds.height / 2 - 100)
        return CGRect(origin: point, size: CGSize(width: 200, height: 200))
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.cornerRadius = 15
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}
