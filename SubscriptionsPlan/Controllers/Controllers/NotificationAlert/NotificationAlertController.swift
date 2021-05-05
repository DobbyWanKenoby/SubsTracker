//
//  NotificationAlertController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 14.01.2021.
//

import UIKit

class NotificationAlertController: UIViewController {
    
    @IBOutlet var symbolImage: UIImageView!
    @IBOutlet var textLabel: UILabel!
    var text: String = ""
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect()
        configureRootView()
        configureElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sleep(1)
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        view.insertSubview(blurView, at: 0)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .secondaryLabel)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        vibrancyView.frame = view.frame
        
        blurView.contentView.addSubview(vibrancyView)
        view.insertSubview(blurView, at: 0)
    }
    
    fileprivate func configureRootView() {
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }
    
    fileprivate func configureElements() {
        symbolImage.image = image
        textLabel.text = text
    }

}
