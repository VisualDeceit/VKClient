//
//  FeedController.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.01.2021.
//

import UIKit

let feedCellID = "FeedCell"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: feedCellID)
        collectionView.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsFeed.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell =  collectionView.dequeueReusableCell(withReuseIdentifier: feedCellID, for: indexPath) as! FeedCell
        feedCell.post = newsFeed[indexPath.item]
        return feedCell
    }
    
    
    //Feed cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var textHeight: CGFloat = 0
        
        //MARK: - Calculate text height
        if let contentText =  newsFeed[indexPath.row].text {
            let rect = NSString(string: contentText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
            
            textHeight = rect.height
        }
        
        let imagesHeight = calculateImageHeight(images: newsFeed[indexPath.item].image, width: view.frame.width)
        
        return .init(width: view.frame.width, height: 60 + textHeight + imagesHeight + 24 )
    }
}

 //ячейка новостей
class FeedCell: UICollectionViewCell {
    
    var post: Post! {
        didSet {
            profileImageView.image = post.logo
            nameLabel.setAttributedText(text: post.caption, subtext: post.date)
            if let text = post.text {
                contentText.text = text
            }

            contentImages = post.image
            let imagesHeight = calculateImageHeight(images: contentImages, width: self.frame.width)
            imageViewStackHeight?.constant = imagesHeight
            
            imageViewsArray.forEach {
                $0.isHidden = true
                $0.image = nil
            }
            
            if let images  = contentImages {
                for i in 0..<images.count {
                    if i >= 4  { break }
                    imageViewsArray[i].image = images[i]
                    imageViewsArray[i].isHidden = false
                }
                
                if images.count > 2 {
                    imageViewsArray[0].addConstraint(imageViewsArray[0].widthAnchor.constraint(equalToConstant: self.frame.width * 2/3))
                    imageViewsArray[0].translatesAutoresizingMaskIntoConstraints = false
                }
            }
         //  layoutIfNeeded()
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

        imageViewsArray.forEach {
            $0.isHidden = true
            $0.image = nil
        }
        
        layoutIfNeeded()
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
    
    let imageView0: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
      //  imageView.backgroundColor = .red
        return imageView
    }()
    let imageView1: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
      //  imageView.backgroundColor = .red
        return imageView
    }()
    let imageView2: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        //imageView.backgroundColor = .red
        return imageView
    }()
    let imageView3: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
       // imageView.backgroundColor = .red
        return imageView
    }()

    let imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
       // stackView.backgroundColor = .blue
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let subImagesStackView: UIStackView = {
        let stackView = UIStackView()
       // stackView.backgroundColor = .green
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    var imageViewsArray = [UIImageView]()
    
    var imageViewStackHeight: NSLayoutConstraint?

    func setupViews() {
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(contentText)
        addSubview(imagesStackView)
        
        imagesStackView.addArrangedSubview(imageView0)
        imagesStackView.addArrangedSubview(subImagesStackView)
        subImagesStackView.addArrangedSubview(imageView1)
        subImagesStackView.addArrangedSubview(imageView2)
        subImagesStackView.addArrangedSubview(imageView3)
        
        imageViewsArray.append(imageView0)
        imageViewsArray.append(imageView1)
        imageViewsArray.append(imageView2)
        imageViewsArray.append(imageView3)
        

        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentText)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: imagesStackView)
        addConstrainsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstrainsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2]|", views: profileImageView, contentText, imagesStackView)
        imageViewStackHeight = imagesStackView.heightAnchor.constraint(equalToConstant: 100)
        imagesStackView.addConstraint(imageViewStackHeight!)
    }
}

//MARK: - Calculate image height
fileprivate func calculateImageHeight (images: [UIImage]?, width: CGFloat) -> CGFloat {
    
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

fileprivate func setImages (images: [UIImage]?) {
    
}

extension UILabel {
    func setAttributedText(text: String, subtext: String) {
 
        let paragrathStyle = NSMutableParagraphStyle()
        paragrathStyle.lineSpacing = 4
        
        let firstLineAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14.0),
            .paragraphStyle: paragrathStyle
        ]
        let secontLineAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor(white: 0.6, alpha: 1)
        ]
        
        let firstLine = NSMutableAttributedString(string: text, attributes: firstLineAttributes)
        let secodLine = NSMutableAttributedString(string: "\n"+subtext, attributes: secontLineAttributes)
       
        firstLine.append(secodLine)
   
        self.numberOfLines = 2
        self.attributedText = firstLine
        
    }
}

extension UIView {
    func addConstrainsWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewDictionary))
    
    }
}
