//
//  AddSubsTransitionAnimationManager.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

class AddSubsTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var startGlobalPoint: CGPoint!
    var startLocalPoint: CGPoint!
    var startSize: CGSize!
    var cellView: UIView!
    var cellRootView: UIView!
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AddSubsAnimationDismissController()
        controller.cellFinishGlobalPoint = startGlobalPoint
        controller.cellFinishLocalPoint = startLocalPoint
        controller.cellFinishSize = startSize
        controller.cellView = cellView
        controller.cellRootView = cellRootView
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AddSubsAnimationPresentationController()
        controller.cellView = cellView
        controller.cellStartPoint = startGlobalPoint
        return controller
    }
}
