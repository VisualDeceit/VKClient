//
//  SwipePhotoGalleryViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 26.12.2020.
//

import UIKit

class SwipePhotoGalleryViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    
    var datasource =  [Photo]()
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView1.image = datasource[index].imageData
    }
    

}
