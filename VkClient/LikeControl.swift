//
//  LikeControl.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.12.2020.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    var totalCount: Int = 0 {
        didSet {
            //обновляем кол-во лайком
            button.setTitle("\(totalCount)", for: .normal)
        }
    }
    
    var isLiked: Bool = false {
        didSet {
            //обнволяем картинку сердца
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
        
        self.addSubview(button)
        
        //настройки
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .red
        //добавляем таргет при нажатии на контрол
        button.addTarget(self, action: #selector(tapControl(_:)), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        
        //слева
        button.frame = self.bounds
        button.contentHorizontalAlignment = .leading
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.contentEdgeInsets.left = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //обработчик нажатия на контрол
    @objc private func tapControl(_ sender: UIButton) {
        isLiked.toggle()
        totalCount = isLiked ? (totalCount + 1) : (totalCount - 1)
        animate()
        //отправлеем экшн "наружу"
        self.sendActions(for: .valueChanged)
    }
    
    
    //MARK: - анимация
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

