//
//  NotificationAlertTransitionManager.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 14.01.2021.
//

import UIKit
import SwiftCoordinatorsKit

class NotificationAlertTransitionManager: NSObject, SCKTransitionDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return NotificationAlertPresentationController(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = NotificationAlertDismissAnimationController()
        return controller
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = NotificationAlertAnimationController()
        return controller
    }

}
