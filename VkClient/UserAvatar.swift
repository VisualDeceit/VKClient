//
//  UserAvatar.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

class UserAvatar: UIView {

    let logo = UIImageView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        logo.frame(forAlignmentRect: rect)
        logo.layer.cornerRadius = 10
        logo.clipsToBounds = true
        addSubview(logo)
    }
    
}
