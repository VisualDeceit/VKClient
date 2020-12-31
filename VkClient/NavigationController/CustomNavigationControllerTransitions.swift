//
//  CustomNavigationControllerTransitions.swift
//  VkClient
//
//  Created by Alexander Fomin on 31.12.2020.
//

import UIKit


// Вперед
class PushNavigationControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
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
        destination.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
       
        destination.view.layer.shadowColor = UIColor.black.cgColor
        destination.view.layer.shadowOpacity = 1
        destination.view.layer.shadowOffset = .zero
        destination.view.layer.shadowRadius = 10
        destination.view.clipsToBounds = false
   
        //анимация
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
                destination.view.transform = .identity

        } completion:  {  finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.view.transform = .identity
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
}

//назад
class PopNavigationControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
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
        source.view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = source.view.frame
        
        source.view.layer.shadowColor = UIColor.black.cgColor
        source.view.layer.shadowOpacity = 1
        source.view.layer.shadowOffset = .zero
        source.view.layer.shadowRadius = 10
        source.view.clipsToBounds = false

        
        
        //анимация
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            source.view.transform = CGAffineTransform(rotationAngle: -.pi / 2)
            
        } completion:  {  finished in
            if finished && !transitionContext.transitionWasCancelled {
                source.removeFromParent()
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
}
