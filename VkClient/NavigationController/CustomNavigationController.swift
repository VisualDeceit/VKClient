//
//  CustomNavigationController.swift
//  VkClient
//
//  Created by Alexander Fomin on 31.12.2020.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let interactiveTransition = InteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }

}

extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            self.interactiveTransition.animatedViewController = toVC
            self.interactiveTransition.recognizerViewController = fromVC
            return PushNavigationControllerTransition()
        case .pop:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.recognizerViewController = fromVC
                self.interactiveTransition.animatedViewController = toVC
            }
            return PopNavigationControllerTransition()
        default:
            return nil
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
        
    }
}
