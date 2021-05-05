//
//  AddSubsTransitionAnimationManager.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

class AddSubsTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var startPoint: CGPoint!
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AddSubsAnimationDismissController()
        controller.finishPoint = startPoint
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AddSubsAnimationPresentationController()
        controller.startPoint = startPoint
        return controller
    }
}
