//
//  FeedCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.01.2021.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    var post: Post! {
        didSet {
            profileImageView.image = post.logo
            nameLabel.setAttributedText(text: post.caption, subtext: post.date)
            
            if let text = post.text {
                contentText.text = text
            }
            
            contentImageViews.forEach{ $0.isHidden = true }
            
            contentImages = post.image
            if let images = contentImages {
                for i in 0..<images.count {
                    if i >= 4  { break }
                    contentImageViews[i].image = images[i]
                    contentImageViews[i].isHidden = false
                }
            }
            
            likeControl.totalCount = post.like.totalCount
            likeControl.isLiked = post.like.isLiked
            
            setupContentImagesSize()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        profileImageView.image = nil
        contentText.text = nil
        contentImageViews.forEach { $0.image = nil }
    }
    
    let nameLabel = UILabel()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let contentText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var contentImages: [UIImage]?
    var contentImageViews = [UIImageView]()
    var contentImageViewsHeight: NSLayoutConstraint?
    var contentImageViewsAspect1: NSLayoutConstraint?
    var contentImageViewsAspect2: NSLayoutConstraint?
    
    let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let subImagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let devider: UIView = {
        let view =  UIView()
        view.backgroundColor = .init(white: 0.8, alpha: 1)
        return view
    }()
    
    let likeControl = LikeControl()
    
    func setupContentImagesSize() {
        
        let imagesHeight = calculateImageHeight(images: contentImages, width: self.frame.width)
        contentImageViewsHeight?.constant = imagesHeight
        
        NSLayoutConstraint.deactivate([contentImageViewsAspect1!, contentImageViewsAspect2!])
        if let images  = contentImages {
            switch images.count {
            case 1:
                imagesStackView.spacing = 0
            case 2:
                NSLayoutConstraint.activate([contentImageViewsAspect1!])
                imagesStackView.spacing = 4
            case 3...:
                NSLayoutConstraint.activate([contentImageViewsAspect2!])
                imagesStackView.spacing = 4
            default:
                ()
            }
        }
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(contentText)
        addSubview(imagesStackView)
        addSubview(devider)
        addSubview(likeControl)
        
        
        for _ in 0...3 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentImageViews.append(imageView)
        }
        
        imagesStackView.addArrangedSubview(contentImageViews[0])
        imagesStackView.addArrangedSubview(subImagesStackView)
        subImagesStackView.addArrangedSubview(contentImageViews[1])
        subImagesStackView.addArrangedSubview(contentImageViews[2])
        subImagesStackView.addArrangedSubview(contentImageViews[3])
        
        
        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentText)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: imagesStackView)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: devider)
        addConstrainsWithFormat(format: "H:|[v0(100)]|", views: likeControl)
        addConstrainsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstrainsWithFormat(format: "V:|-8-[v0(44)]-8-[v1]-4-[v2]-4-[v3(1)]-4-[v4(30)]|", views: profileImageView, contentText, imagesStackView, devider, likeControl)
        
        contentImageViewsHeight = imagesStackView.heightAnchor.constraint(equalToConstant: 100)
        imagesStackView.addConstraint(contentImageViewsHeight!)
        
        contentImageViewsAspect1 = contentImageViews[0].widthAnchor.constraint(equalTo: subImagesStackView.widthAnchor, multiplier: 1)
        contentImageViewsAspect2 = contentImageViews[0].widthAnchor.constraint(equalTo: subImagesStackView.widthAnchor, multiplier: 3)
    }
}

//MARK: - Calculate image height
func calculateImageHeight (images: [UIImage]?, width: CGFloat) -> CGFloat {
    
    guard let unwrapImages = images else {
        return 0
    }
    
    switch unwrapImages.count {
    case 1:
        let ratio =  unwrapImages.first!.getCropRatio()
        return width / ratio
    default:
        return width
    }
}
