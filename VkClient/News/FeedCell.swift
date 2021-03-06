//
//  FeedCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.01.2021.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    //для сохранения запрошенного адреса
    var imageURL: URL?
        
    var newsPost: NewsPost! {
        didSet {
            
            imageURL = URL(string: newsPost.avatarUrl)
            profileImageView.logoView.download(from: (imageURL)!) {[weak self] url in
                self?.imageURL == url
            }
            
            let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSince1970: Double(newsPost.date))
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            nameLabel.setAttributedText(text: newsPost.name, subtext: localDate)
            
            contentText.text = newsPost.text
            
            let imageGroup = DispatchGroup()
            
            if let attachments = newsPost.attachments {
                for i in 0..<attachments.count {
                    if  attachments[i].type != "photo" {
                        continue
                    }
                    DispatchQueue.global().async(group: imageGroup) {
                        if let url = URL(string: attachments[i].url),
                           let data = try? Data(contentsOf: url) {
                            self.contentImages?.append(UIImage(data: data)!)
                        }
                    }
                }
            }


            
            likeButton.totalCount = newsPost.likesCount
            likeButton.isLiked = (newsPost.isLiked != 0)
            var viewsCountString = ""
            let viewsCount =  newsPost.viewsCount ?? 0
                if viewsCount < 1000 {
                    viewsCountString = "\(viewsCount)"
                } else {
                    viewsCountString = String(format: "%.1fk", Double(viewsCount)/1000.0)
                }
            viewsButton.setTitle(viewsCountString, for: .normal)
            
            
            
            imageGroup.notify(queue: DispatchQueue.main) {
                self.contentImageViews.forEach{ $0.isHidden = true }
                
                if let images = self.contentImages {
                    for i in 0..<images.count {
                        if i >= 4  { break }
                        self.contentImageViews[i].image = images[i]
                        self.contentImageViews[i].isHidden = false
                    }
                }
                self.setupContentImagesSize()
            }
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
        profileImageView.logoView.image = nil
        contentText.text = nil
        contentImages?.removeAll()
        contentImageViews.forEach { $0.image = nil }
    }
    
    let nameLabel = UILabel()
    
    let profileImageView = CellLogo()
    
    let contentText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        return label
    }()
    
    var contentImages: [UIImage]? = []
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
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let devider: UIView = {
        let view =  UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    let likeButton = LikeControl()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        //для выравнивания символов по высоте
        let imgConfig = UIImage.SymbolConfiguration(scale: .medium)
        let message = UIImage(systemName: "message", withConfiguration: imgConfig)
        button.setImage(message, for: .normal)
        button.tintColor = .label
       return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        //для выравнивания символов по высоте
        let imgConfig = UIImage.SymbolConfiguration(scale: .medium)
        let share = UIImage(systemName: "repeat", withConfiguration: imgConfig)
        button.setImage(share, for: .normal)
        button.tintColor = .label
       return button
    }()
    
    let viewsButton: UIButton = {
        let button = UIButton(type: .system)
        //для выравнивания символов по высоте
        let imgConfig = UIImage.SymbolConfiguration(scale: .medium)
        let views = UIImage(systemName: "eye", withConfiguration: imgConfig)
        button.setImage(views, for: .normal)
       // button.setTitle("15k", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.isEnabled = false
       return button
    }()
    
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
        
        backgroundColor = .systemBackground
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(contentText)
        addSubview(imagesStackView)
        addSubview(devider)
        addSubview(bottomStackView)
        
        //profileImageView.shadowRadius = 22
 
        // наполняем  array imageviews
        for _ in 0...3 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            contentImageViews.append(imageView)
        }
        
        //область с картинками
        imagesStackView.addArrangedSubview(contentImageViews[0])
        imagesStackView.addArrangedSubview(subImagesStackView)
        subImagesStackView.addArrangedSubview(contentImageViews[1])
        subImagesStackView.addArrangedSubview(contentImageViews[2])
        subImagesStackView.addArrangedSubview(contentImageViews[3])
        
        //нижняя область с кнопками
        bottomStackView.addArrangedSubview(likeButton)
        bottomStackView.addArrangedSubview(commentButton)
        bottomStackView.addArrangedSubview(shareButton)
        bottomStackView.addArrangedSubview(viewsButton)
        
        //настройка ограничений
        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentText)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: imagesStackView)
        addConstrainsWithFormat(format: "H:|-12-[v0]-12-|", views: devider)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: bottomStackView)
        addConstrainsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstrainsWithFormat(format: "V:|-8-[v0(44)]-8-[v1]-4-[v2]-12-[v3(1)]-4-[v4(30)]|", views: profileImageView, contentText, imagesStackView, devider, bottomStackView)
        
        //высота поля с картинками
        contentImageViewsHeight = imagesStackView.heightAnchor.constraint(equalToConstant: 100)
        imagesStackView.addConstraint(contentImageViewsHeight!)
        
        //соотношение сторон для области картинок в зависимоти от кол-ва
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
