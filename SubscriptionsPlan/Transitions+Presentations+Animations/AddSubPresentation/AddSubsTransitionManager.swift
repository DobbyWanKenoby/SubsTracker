//
//  AddSubsTransitionAnimationManager.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit
import SwiftCoordinatorsKit

struct AddSubsTransitionData: TransitionData{
    var startGlobalPoint: CGPoint!
    var startLocalPoint: CGPoint!
    var startSize: CGSize!
    var cellView: UIView!
    var cellRootView: UIView!
}

class AddSubsTransitionManager: NSObject, SCKTransitionDelegate {
    
    private var transitionData: AddSubsTransitionData!
    
    required init(transitionData data: TransitionData?) {
        guard let data = data as? AddSubsTransitionData else {
            fatalError("Transition manager \(Self.self) can not work without transitionData or data with wrong structure. Transition data must be AddSubsTransitionData struct")
        }
        super.init()
        transitionData = data
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return OverlayPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AddSubsAnimationDismissController()
        controller.cellFinishGlobalPoint = transitionData.startGlobalPoint
        controller.cellFinishLocalPoint = transitionData.startLocalPoint
        controller.cellFinishSize = transitionData.startSize
        controller.cellView = transitionData.cellView
        controller.cellRootView = transitionData.cellRootView
        return controller
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = AddSubsAnimationPresentationController()
        controller.cellView = transitionData.cellView
        controller.cellStartPoint = transitionData.startGlobalPoint
        return controller
    }
}
