//
//  OverlayPresenterController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit

class OverlayPresentationController: UIPresentationController {
    
    private var visualEffectView: UIVisualEffectView!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(x: 0, y: 50, width: containerView!.frame.width, height: containerView!.frame.height - 50)
    }
    
    override func presentationTransitionWillBegin() {
        let frame = containerView!.frame
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = frame
        visualEffectView.layer.opacity = 0
        containerView?.addSubview(visualEffectView)
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.layer.opacity = 1
        })
    }
    
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.3, animations: {
            self.visualEffectView.layer.opacity = 0
        }, completion: { _ in
            self.visualEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.cornerRadius = 10
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
}
