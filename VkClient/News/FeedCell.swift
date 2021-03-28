//
//  FeedCell.swift
//  VkClient
//
//  Created by Alexander Fomin on 10.01.2021.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    static let identifier = "FeedCell"
    
    var indexPath: IndexPath! 
    
    var newsPost: NewsPost! {
        didSet {
            setPostLogo()
            setPostCaption()
            setPostParam()
            setPostContent()
            setNeedsLayout()
        }
    }
    
    var imageURL: URL?
    var attachURL: [URL]?
    var stringDate: String = ""
    var contentImages: [UIImage]? = []
    var contentImageViews = [UIImageView]()
    var contentImageViewsHeight: NSLayoutConstraint?
    var subcontentImageViewsHeight: NSLayoutConstraint?
    var contentImageViewsAspect1: NSLayoutConstraint?
    var contentImageViewsAspect2: NSLayoutConstraint?
    
    
    //let iconImageView = CellLogo()
    let likeButton = LikeControl()
    let iconImageView =  UIImageView()
    ///Показывать или нет кнопку "Show more..."
    var isShowMoreButton = false
    ///true - развернут, false - свернут
    var isShowMore: Bool! {
        didSet {
            let buttonTitle = isShowMore ? "Show less..." : "Show more..."
            showMoreButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    let captionName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.backgroundColor = .systemBackground
        return label
    }()
    
    let captionDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor =  UIColor(white: 0.6, alpha: 1)
        label.backgroundColor = .systemBackground
        return label
    }()
    
    
    let contentText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.backgroundColor = .systemBackground
        return label
    }()
        
    let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let subImagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemBackground
        return stackView
    }()
    
    let devider: UIView = {
        let view =  UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
        
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        //для выравнивания символов по высоте
        let imgConfig = UIImage.SymbolConfiguration(scale: .medium)
        let message = UIImage(systemName: "message", withConfiguration: imgConfig)
        button.setImage(message, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .systemBackground
        button.tintColor = .label
       return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        //для выравнивания символов по высоте
        let imgConfig = UIImage.SymbolConfiguration(scale: .medium)
        let share = UIImage(systemName: "repeat", withConfiguration: imgConfig)
        button.setImage(share, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .systemBackground
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
        button.backgroundColor = .systemBackground
       return button
    }()
    
    let showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .systemBackground
        button.setTitle("Show more...", for: .normal)
        button.contentHorizontalAlignment = .leading
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

        captionName.text = nil
        captionDate.text = nil
        iconImageView.image = nil
        contentText.text = nil
        contentImages?.removeAll()
        contentImageViews.forEach { $0.image = nil }
        stringDate = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageViewFrame()
        captionNameFrame()
        captionDateFrame()
        contentTextFrame()
        showMoreButtonFrame()
        imagesStackViewFrame()
        deviderFrame()
        bottomStackViewFrame() 
    }

    
    // загрузка аватара
    private func setPostLogo() {
        imageURL = URL(string: newsPost.avatarUrl)
        iconImageView.download(from: (imageURL)!) {[weak self] url in
            self?.imageURL == url
        }
    }
    
    ///Функция заполнения заголовка поста
    private func setPostCaption() {
        captionName.text = newsPost.name
        captionDate.text = stringDate
    }
    
    private func postParamToString(countInt: Int?) -> String{
        let count = countInt ?? 0
            if count < 1000 {
               return String(count)
            } else {
                return String(format: "%.1fk", Double(count)/1000.0)
            }
    }
    
    ///Функция заполнениия statusbar поста -
    ///нравится, комментарии, просмотры
    private func setPostParam() {
        //лайки и просмотры
        likeButton.totalCount = newsPost.likesCount
        likeButton.isLiked = (newsPost.isLiked != 0)

        viewsButton.setTitle(postParamToString(countInt: newsPost.viewsCount), for: .normal)
        commentButton.setTitle(postParamToString(countInt: newsPost.commentsCount), for: .normal)
        shareButton.setTitle(postParamToString(countInt: newsPost.repostsCount), for: .normal)
    }
    
    ///Функция заполнения поста содержимым
    private func setPostContent(){
        contentText.text = newsPost.text
        self.contentImageViews.forEach { $0.isHidden = true }
        let imageGroup = DispatchGroup()
        //есть содержимое
        if let attachments = newsPost.attachments {
            attachURL?.removeAll()
            for i in 0..<attachments.count where i < 4 {
                //  эти пока обрабатываем
                guard attachments[i].type == "photo" || attachments[i].type == "video" || attachments[i].type == "link" else { continue }
                
                //сохранияем url
                if attachURL?.append(URL(string: attachments[i].url)!) == nil {
                    attachURL = [ URL(string: attachments[i].url)! ]
                }
                
                //создаем очередь
                imageGroup.enter()
                if let url = URL(string: attachments[i].url) {
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
            setNeedsLayout()
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
            self.setNeedsLayout()
        }
    }
    
    
    //MARK: - Frames Layout
    let spacer: CGFloat = 8
    
    func iconImageViewFrame() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = true
        let iconSideLenght: CGFloat = 44
        let iconSize = CGSize(width: iconSideLenght, height: iconSideLenght)
        let iconOrigin = CGPoint(x: spacer, y: spacer)
        iconImageView.frame = CGRect(origin: iconOrigin, size: iconSize)
    }
    
    func getCaptionSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - spacer * 3 - iconImageView.frame.width
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byTruncatingTail
        let rect = text.boundingRect(with: textBlock, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func captionNameFrame() {
        let captionNameSize = getCaptionSize(text: newsPost.name, font: captionName.font)
        let captionNameX = iconImageView.frame.width + spacer * 2
        let captionNameOrigin =  CGPoint(x: captionNameX, y: spacer)
        captionName.frame = CGRect(origin: captionNameOrigin, size: captionNameSize)
    }
    
    func captionDateFrame() {
        let captionDateSize = getCaptionSize(text: stringDate, font: captionDate.font)
        let captionDateX = iconImageView.frame.width + spacer * 2
        let captionDateY = captionName.frame.origin.y + captionName.frame.height + spacer
        let captionDateOrigin =  CGPoint(x: captionDateX, y: captionDateY)
        captionDate.frame = CGRect(origin: captionDateOrigin, size: captionDateSize)
    }
    
    func getContentTextSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - spacer * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let rect = text.boundingRect(with: textBlock, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func contentTextFrame() {
        var contentTextSize: CGSize
        if newsPost.text == "" {
            contentTextSize = .zero
        } else {
            contentTextSize = getContentTextSize(text: contentText.text ?? "", font: contentText.font)
        }
        //нужно показать кнопку
        isShowMoreButton = contentTextSize.height > 200 ? true : false
        //текст не развернут
        if isShowMoreButton, !isShowMore {
            contentTextSize.height = 200
        }
        let contentTextX = spacer
        let contentTextY = iconImageView.frame.origin.y + iconImageView.frame.height + spacer
        let contentTextOrigin = CGPoint(x: contentTextX, y: contentTextY)
        contentText.frame = CGRect(origin: contentTextOrigin, size: contentTextSize)
    }
    
    func showMoreButtonFrame() {
        guard isShowMoreButton else {
            let buttonSize = CGSize.zero
            let buttonOrigin = CGPoint(x: 0, y: 0)
            showMoreButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
            return
        }

        let buttonLength = bounds.width - 2 * spacer
        let buttonSize = CGSize(width: buttonLength, height: 14)
        let buttonX = spacer
        let buttonY = contentText.frame.origin.y + contentText.frame.height + (!isShowMore ? 0 : 8)
        let buttonOrigin = CGPoint(x: buttonX, y: buttonY)
        showMoreButton.frame = CGRect(origin: buttonOrigin, size: buttonSize)
    }
    
    func imagesStackViewFrame() {
        let imagesHeight = calculateImageHeight(images: contentImages, width: self.frame.width )
        let imagesStackViewSize = CGSize(width: self.frame.width, height: imagesHeight)
        
        let imagesStackViewY: CGFloat
        
        if isShowMoreButton {
            imagesStackViewY = showMoreButton.frame.origin.y + showMoreButton.frame.height + spacer
        } else {
            imagesStackViewY = contentText.frame.origin.y + contentText.frame.height + (contentText.frame.height == 0 ? 0 : spacer)
        }
        
        let imagesStackViewOrigin =  CGPoint(x: 0, y: imagesStackViewY)
        imagesStackView.frame = CGRect(origin: imagesStackViewOrigin, size: imagesStackViewSize)
        imagesStackView.spacing = contentImages?.count ?? 0 > 1 ? 4 : 0
    }
    
    func deviderFrame() {
        let devideLength = bounds.width - 4 * spacer
        let deviderSize = CGSize(width: devideLength, height: 1)
        let deviderX = 2 * spacer
        let deviderY = imagesStackView.frame.origin.y + imagesStackView.frame.height + (imagesStackView.frame.height == 0 ? 0 : spacer)
        let deviderOrigin = CGPoint(x: deviderX, y: deviderY)
        devider.frame = CGRect(origin: deviderOrigin, size: deviderSize)
    }
    
    func bottomStackViewFrame() {
        let bottomStackViewSize = CGSize(width: bounds.width - 2 * spacer, height: 30)
        let bottomStackViewX =  spacer
        let bottomStackViewY = devider.frame.origin.y + devider.frame.height + spacer
        let bottomStackViewOrigin = CGPoint(x: bottomStackViewX, y: bottomStackViewY)
        bottomStackView.frame = CGRect(origin: bottomStackViewOrigin, size: bottomStackViewSize)
    }
    
    
    func setupViews() {
        
        backgroundColor = .systemBackground
        
        addSubview(captionName)
        addSubview(captionDate)
        addSubview(iconImageView)
        addSubview(contentText)
        addSubview(showMoreButton)
        addSubview(imagesStackView)
        addSubview(devider)
        addSubview(bottomStackView)

        // наполняем  array imageviews
        for _ in 0...3 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
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
        
        showMoreButton.addTarget(self, action: #selector(expandText), for: .touchUpInside)
    }
    
    // MARK: - Expand/collapse text
    @objc func expandText() {
        isShowMore.toggle()
        let buttonTitle = isShowMore ? "Show less..." : "Show more..."
        showMoreButton.setTitle(buttonTitle, for: .normal)
        // передаем в контроллер словарь Индекс:Развернут_ли_текст
        let reloadCellNotification = Notification.Name("reloadCell")
        NotificationCenter.default.post(name: reloadCellNotification, object: nil, userInfo: [self.indexPath!: isShowMore ?? false])
    }
    
}

//MARK: - Calculate images height
func calculateImageHeight (images: [UIImage]?, width: CGFloat) -> CGFloat {
    guard let unwrapImages = images,
          images?.count != 0
    else { return 0 }
    
    switch unwrapImages.count {
    case 1:
        let ratio =  unwrapImages.first!.getCropRatio()
        return width / ratio
    default:
        return width
    }
    
}
