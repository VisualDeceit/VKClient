//
//  MainTabBarController.swift
//  VkClient
//
//  Created by Alexander Fomin on 04.01.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        self.viewControllers! += [feedController]


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
