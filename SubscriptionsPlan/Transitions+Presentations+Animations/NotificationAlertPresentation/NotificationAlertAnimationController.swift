//
//  NotificationAlertAnimationController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 14.01.2021.
//

import UIKit

class NotificationAlertAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let presentingView = transitionContext.view(forKey: .to)!
        transitionContext.containerView.addSubview(presentingView)
        presentingView.layer.opacity = 0
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentingView.layer.opacity = 1
            presentingView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            
        })
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: .curveEaseIn, animations: {
            presentingView.transform = .identity
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
        return
    }
}
