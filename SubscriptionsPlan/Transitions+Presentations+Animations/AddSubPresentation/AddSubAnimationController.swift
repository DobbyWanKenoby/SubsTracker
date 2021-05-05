//
//  AddSubAniamtionController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit
import AVFoundation

class AddSubsAnimationPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var startPoint: CGPoint = .zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let tapticGenerator = UISelectionFeedbackGenerator()
        tapticGenerator.selectionChanged()
        
        let presentingView = transitionContext.view(forKey: .to)!
        transitionContext.containerView.addSubview(presentingView)

        let startScreenFrame = CGRect(
            origin: CGPoint(x: 0, y: startPoint.y-47),
            size: CGSize(width: UIScreen.main.bounds.size.width, height: 140))
        presentingView.frame = startScreenFrame
        presentingView.layer.cornerRadius = 10
        presentingView.layer.masksToBounds = true
        presentingView.transform = CGAffineTransform(scaleX: 0.915, y: 0.915)

        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentingView.frame = transitionContext.containerView.frame
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
        return
    }
}

class AddSubsAnimationDismissController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var finishPoint: CGPoint!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    // Во время анимации сложная иерархия View подменяется на мгновенный снимок
    // И уже он уменьшается до необходимых размеров
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // данные получены опытным путем
        let finishSize = CGSize(width: UIScreen.main.bounds.size.width-32, height: 78)
        let finishOriginPoint = CGPoint(x: 16, y: finishPoint.y+8)

        guard let presentingView = transitionContext.viewController(forKey: .from)?.view else {
            return
        }
        guard let snapshotPresentingView = presentingView.snapshotView(afterScreenUpdates: true) else {
            return
        }
        snapshotPresentingView.frame.size = presentingView.frame.size
        let containerView = UIView(frame: presentingView.frame)
        containerView.addSubview(snapshotPresentingView)
        transitionContext.containerView.addSubview(containerView)
        presentingView.removeFromSuperview()
        containerView.layer.masksToBounds = true
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.frame = CGRect(origin: finishOriginPoint, size: finishSize)
            }, completion: {_ in
                containerView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }
}
