//
//  UserAvatar.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

class UserAvatar: UIView {

    var logo = UIImageView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        logo.frame = rect
        logo.layer.cornerRadius = logo.frame.height / 2
        logo.clipsToBounds = true
        self.addSubview(logo)
    }
   
}
