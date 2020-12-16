//
//  LikeControl.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

class LikeControl: UIControl {
    
    var likesCount: Int = 0 {
        didSet {
            button.setTitle("\(likesCount)", for: .normal)
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            //let defaultImage =  oldValue ? self.likedImage : self.unlikedImage
            button.setImage(isLiked ? self.likedImage : self.unlikedImage, for: .normal)
        }
    }
    
    private var button = UIButton(type: .custom)
    private let unlikedImage = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)
    private let likedImage = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
    private let unlikedScale: CGFloat = 0.8
    private let likedScale: CGFloat = 1.2
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setupView(){
        
        //let defaultImage = self.isLiked ? self.likedImage : self.unlikedImage
        //button.setImage(defaultImage, for: .normal)
        //button.setImage(unlikedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(pushLikeButton(_:)), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        
        self.addSubview(button)
        self.contentHorizontalAlignment = .left
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
    }
    
    @objc private func pushLikeButton(_ sender: UIButton) {
        isLiked.toggle()
        likesCount = isLiked ? (likesCount + 1) : (likesCount - 1)
        animate()
        self.sendActions(for: .valueChanged)
    }
    
    
    private func animate() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked ? self.likedImage : self.unlikedImage
            let newScale = self.isLiked ? self.likedScale : self.unlikedScale
            self.button.transform = self.transform.scaledBy(x: newScale, y: newScale)
            self.button.setImage(newImage, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.button.transform = CGAffineTransform.identity
            })
        })
    }
    
}

