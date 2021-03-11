//
//  FeedCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.01.2021.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    var imageURL: URL?
    var attachURL: [URL]?
        
    var newsPost: NewsPost! {
        didSet {
            setPostLogo()
            setPostCaption()
            setPostParam()
            setPostContent()
        }
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
    var subcontentImageViewsHeight: NSLayoutConstraint?
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

        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.isEnabled = false
       return button
    }()
    
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
    
    // загрузка аватара
    private func setPostLogo() {
        imageURL = URL(string: newsPost.avatarUrl)
        profileImageView.logoView.download(from: (imageURL)!) {[weak self] url in
            self?.imageURL == url
        }
    }
    
    //заголовок поста
    private func setPostCaption() {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: Double(newsPost.date))
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeZone = .current
        nameLabel.setAttributedText(text: newsPost.name, subtext: dateFormatter.string(from: date))
    }
    
    //лайки просмотры и пт
    private func setPostParam() {
        //лайки и просмотры
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
    }
    
    //содержимое поста
    private func setPostContent(){
        
        contentText.text = newsPost.text
        
        self.contentImageViews.forEach { $0.isHidden = true }
        
        let imageGroup = DispatchGroup()
        
        //есть содержимое
        if let attachments = newsPost.attachments {
            
            attachURL?.removeAll()
            
            for i in 0..<attachments.count where i < 4 {
                
                //  эти пока обрабатываем
                // if attachments[i].type == "doc"  || attachments[i].type == "poll"  { continue }
                guard attachments[i].type == "post" || attachments[i].type == "video" || attachments[i].type == "link" else { continue }
                
                subcontentImageViewsHeight?.isActive = false
                
                //сохранияем url
                if attachURL?.append(URL(string: attachments[i].url)!) == nil {
                    attachURL = [ URL(string: attachments[i].url)! ]
                }
                //создаем очередь
                
                if let url = URL(string: attachments[i].url) {
                    imageGroup.enter()
                    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
                    URLSession.shared.dataTask(with: request) { (data, _, _) in
                        if let tempData = data,
                           let image = UIImage(data: tempData) {
                            //если это запрашиваемый url
                            if self.attachURL!.contains(url) {
                                self.contentImages?.append(image)
                            }
                        }
                        imageGroup.leave()
                    }.resume()
                }
            }
        } else { //нет прикрепленного
            //сжимаем область картинок
            contentImageViewsHeight?.constant = 0
            subcontentImageViewsHeight?.isActive = true
            NSLayoutConstraint.deactivate([contentImageViewsAspect1!, contentImageViewsAspect2!])
            layoutIfNeeded()
        }
        
        //все задания из группы закончились
        imageGroup.notify(queue: DispatchQueue.main) {
            self.contentImageViews.forEach { $0.image = nil }
            if let images = self.contentImages {
                for i in 0..<images.count {
                    if i >= 4  { break }
                    self.contentImageViews[i].image = images[i]
                    self.contentImageViews[i].isHidden = false
                }
            }
            self.setupContentImagesSize()
            self.layoutIfNeeded()
        }
    }
    
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
        subcontentImageViewsHeight = subImagesStackView.heightAnchor.constraint(equalToConstant: 0)
        
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
