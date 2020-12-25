//
//  UserAvatar.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

class UserAvatar: UIView {
    
    var logoView = UIImageView()
    let shadowView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
var shadowRadius: CGFloat = 25.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
var shadowBlur: CGFloat = 6.0 {
        didSet {
            setNeedsDisplay()
        }
    }


var shadowOpacity: Float = 0.3 {
        didSet {
            setNeedsDisplay()
        }
    }

var shadowOffset: CGSize = CGSize(width: 0, height: 5) {
        didSet {
            setNeedsDisplay()
        }
    }

var shadowColor: UIColor = UIColor.black {
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
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
            let recognizer = UITapGestureRecognizer(target: self,
                                                    action: #selector(onTap))
            recognizer.numberOfTapsRequired = 1    // Количество нажатий, необходимое для распознавания
            recognizer.numberOfTouchesRequired = 1 // Количество пальцев, которые должны коснуться экрана для распознавания
            return recognizer
        }()
        
        @objc func onTap() {
            let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = transform.self
            scaleAnimation.toValue = 0.8
            scaleAnimation.stiffness = 100
            scaleAnimation.mass = 1
            scaleAnimation.duration = 0.3
            scaleAnimation.damping = 20
//            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
//            scaleAnimation.fromValue = transform.self
//            scaleAnimation.toValue = 0.9
//            scaleAnimation.duration = 0.1
//            scaleAnimation.autoreverses = true
            layer.add(scaleAnimation, forKey: nil)

        }
    
}
