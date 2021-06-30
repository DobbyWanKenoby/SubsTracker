//
//  NotificationAlertTransitionManager.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 14.01.2021.
//

import UIKit

class NotificationAlertTransitionManager: NSObject, SCKTransitionDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return NotificationAlertPresentationController(presentedViewController: presented, presenting: presenting)
    }

//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let controller = AddSubsAnimationDismissController()
//        controller.finishPoint = startPoint
//        return controller
//    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = NotificationAlertAnimationController()
        return controller
    }

}
