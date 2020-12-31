//
//  CustomNavigationController.swift
//  VkClient
//
//  Created by Alexander Fomin on 31.12.2020.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }

}


extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            return PushNavigationControllerTransition()
        case .pop:
            return PopNavigationControllerTransition()
        default:
            return nil
        }
    }
}
