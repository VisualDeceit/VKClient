//
//  CustomNavigationControllerTransitions.swift
//  VkClient
//
//  Created by Alexander Fomin on 31.12.2020.
//

import UIKit


// Вперед
class PushNavigationControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //начальный конроллер
        let source = transitionContext.viewController(forKey: .from)!
        //конечный конроллер
        let destination = transitionContext.viewController(forKey: .to)!
        //добавляем конечное вью в containerView
        transitionContext.containerView.addSubview(destination.view)
        //назначаем фреймы
        source.view.frame = transitionContext.containerView.frame
        destination.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        destination.view.frame = transitionContext.containerView.frame
        //задаем начальное положение
        destination.view.transform = CGAffineTransform(rotationAngle: .pi / 2).concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
        
        //анимация
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: []) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                destination.view.transform = .identity
            }
            
        } completion: {  finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }

    }
    
    
}

//назад
class PopNavigationControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //начальный конроллер
        let source = transitionContext.viewController(forKey: .from)!
        //конечный конроллер
        let destination = transitionContext.viewController(forKey: .to)!
        
        transitionContext.containerView.addSubview(destination.view)
        transitionContext.containerView.sendSubviewToBack(destination.view)
        
        //назначаем фреймы
       /// source.view.frame = transitionContext.containerView.frame
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = source.view.frame
        
        
        //анимация
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: []) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                source.view.transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
            
        } completion: {  finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
        
        
    }
    
    
}
