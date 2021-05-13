//
//  AddSubAniamtionController.swift
//  SubscriptionsPlan
//
//  Created by Vasily Usov on 09.01.2021.
//

import UIKit
import AVFoundation

// MARK: - Переход к сцене

class AddSubsAnimationPresentationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // стартовые и конечные координаты и размеры ячейки
    var cellStartPoint: CGPoint!
    // ячейка, которая расширяется
    var cellView: UIView!
    // фоновое вью
    lazy var whiteBackgroundView: UIView = {
        let whiteBackgroundView = UIView(frame: cellView.frame)
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.layer.cornerRadius = cornerRadius
        whiteBackgroundView.layer.shadowOpacity = 0
        whiteBackgroundView.layer.shadowColor = UIColor.black.cgColor
        whiteBackgroundView.layer.shadowRadius = 6
        whiteBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        whiteBackgroundView.clipsToBounds = false
        return whiteBackgroundView
    }()
    
    private var cornerRadius: CGFloat = 10
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // вибрация
        let tapticGenerator = UISelectionFeedbackGenerator()
        tapticGenerator.selectionChanged()
        
        // вью, к которому происходит переход
        let presentingView = transitionContext.view(forKey: .to)!
        transitionContext.containerView.addSubview(presentingView)
        presentingView.layer.opacity = 0
        
        // переносим вью ячейки из таблицы
        // в новый контроллер
        transitionContext.containerView.addSubview(cellView)
        cellView.frame.origin = cellStartPoint
        cellView.clipsToBounds = true
        self.cellView.layer.cornerRadius = cornerRadius
        
        transitionContext.containerView.insertSubview(whiteBackgroundView, at: 0)
        
        // Описание анимации
        
        var animators = [UIViewPropertyAnimator]()
        
        // Этап 1 анимации
        animators.append( UIViewPropertyAnimator(duration: 0.05, curve: .easeInOut) {
            self.cellView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.whiteBackgroundView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.whiteBackgroundView.layer.shadowOpacity = 0.3
        })
        animators[0].addCompletion { _ in
            animators[1].startAnimation()
        }
        
        // Этап 2 анимации
        animators.append( UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.cellView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.cellView.frame.origin = CGPoint(x: 0, y: -30)
            self.cellView.frame.size.height = 150
            self.cellView.frame.size.width = UIScreen.main.bounds.width
            
            self.whiteBackgroundView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.whiteBackgroundView.frame.origin = CGPoint(x: 0, y: 0)
            self.whiteBackgroundView.frame.size.height = UIScreen.main.bounds.height
            self.whiteBackgroundView.frame.size.width = UIScreen.main.bounds.width
            self.whiteBackgroundView.layer.shadowOpacity = 0.7
        })
        animators[1].addCompletion { _ in
            animators[2].startAnimation()
        }
        
        // Этап 3 анимации
        animators.append( UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.cellView.frame.origin = CGPoint(x: 0, y: 0)
        })
        animators[2].addCompletion { _ in
            animators[3].startAnimation()
        }
        
        // Этап 4 анимации
        animators.append( UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) {
            presentingView.layer.opacity = 1
        })
        animators[3].addCompletion { _ in
            self.whiteBackgroundView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        animators[0].startAnimation()
        
        return
    }
}

// MARK: - Выход со сцены

class AddSubsAnimationDismissController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // ячейка
    var cellView: UIView!
    // финишные координаты и размер ячейки
    var cellFinishSize: CGSize!
    var cellFinishGlobalPoint: CGPoint!
    var cellFinishLocalPoint: CGPoint!
    // исходное корневое вью ячейки
    // сперва ячейка убирается из него
    // а позже - добавляется
    var cellRootView: UIView!
    
    lazy var whiteBackgroundView: UIView = {
        let whiteBackgroundView = UIView(frame: cellView.frame)
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.layer.cornerRadius = 10
        whiteBackgroundView.layer.shadowOpacity = 0.7
        whiteBackgroundView.layer.shadowColor = UIColor.black.cgColor
        whiteBackgroundView.layer.shadowRadius = 6
        whiteBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        whiteBackgroundView.clipsToBounds = false
        return whiteBackgroundView
    }()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    // Во время анимации сложная иерархия View подменяется на мгновенный снимок
    // И уже он уменьшается до необходимых размеров
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentingView = transitionContext.viewController(forKey: .from)?.view else {
            return
        }
        transitionContext.containerView.insertSubview(whiteBackgroundView, at: 1)
        whiteBackgroundView.frame = presentingView.frame
        
        var animators = [UIViewPropertyAnimator]()
        
        animators.append( UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            presentingView.layer.opacity = 0
        })
        animators[0].addCompletion{ _ in
            animators[1].startAnimation()
        }
        
        animators.append( UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) {
            self.cellView.frame.origin.y -= 20
            
        })
        animators[1].addCompletion{ _ in
            animators[2].startAnimation()
        }
        
        animators.append( UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.cellView.frame = CGRect(origin: self.cellFinishGlobalPoint, size: self.cellFinishSize)
            self.whiteBackgroundView.frame = CGRect(origin: self.cellFinishGlobalPoint, size: self.cellFinishSize)
            self.whiteBackgroundView.layer.shadowOpacity = 0
            //self.cellView.transform = .identity
        })
        animators[2].addCompletion{ _ in
            transitionContext.completeTransition(true)
            self.cellRootView.addSubview(self.cellView)
            self.cellView.frame.origin = self.cellFinishLocalPoint
        }
        animators[0].startAnimation()
        
    }
}
