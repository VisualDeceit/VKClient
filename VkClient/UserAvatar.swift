//
//  UserAvatar.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

@IBDesignable class UserAvatar: UIView {
    
    var logoView = UIImageView()
    let shadowView = UIView()
    
    @IBInspectable var shadowRadius: CGFloat = 25.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowBlur: CGFloat = 6.0 {
        didSet {
            setNeedsDisplay()
        }
    }


    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 5) {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //настраивем картинку
        logoView.frame = rect
        logoView.layer.cornerRadius =  shadowRadius
        logoView.clipsToBounds = true
        logoView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        //настраиваем тени
        shadowView.frame = rect
        shadowView.clipsToBounds = false
        shadowView.layer.shadowColor = shadowColor.cgColor
        shadowView.layer.shadowOpacity = shadowOpacity
        shadowView.layer.shadowOffset = shadowOffset
        shadowView.layer.shadowRadius = shadowBlur
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: shadowRadius).cgPath
        
        //накладываем слои
        shadowView.addSubview(logoView)
        self.addSubview(shadowView)
    }
    
}
