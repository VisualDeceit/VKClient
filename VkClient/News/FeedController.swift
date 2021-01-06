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
        
        feedCell.profileImageView.image = newsFeed[indexPath.item].logo
        feedCell.nameLabel.setAttributedText(text: newsFeed[indexPath.item].caption, subtext: newsFeed[indexPath.item].date)
        if let text = newsFeed[indexPath.row].text {
            feedCell.contentText.text = text
        }
        if let images = newsFeed[indexPath.row].image {
            feedCell.imagesGrid = images
        } else {
            feedCell.imagesGrid.removeAll()
        }
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var textheight: CGFloat = 0
        if let contentText =  newsFeed[indexPath.row].text {
            let rect = NSString(string: contentText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
            textheight = rect.height
        }
       return .init(width: view.frame.width, height: 60 + textheight + view.frame.width + 1 )
    }
}

 //ячейка новостей
class FeedCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: photoCellID)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        profileImageView.image = nil
        contentText.text = nil
        contentCollectionView.reloadData()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel = UILabel()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
       // imageView.backgroundColor = .red
        return imageView
    }()
    
    let contentText: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let contentCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .blue
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv;
    }()
    
    var imagesGrid =  [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesGrid.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell =  collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as! PhotoCell
        photoCell.imageView.image = imagesGrid[indexPath.row]
       return photoCell
 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imagesCount = imagesGrid.count == 0  ? 1 : imagesGrid.count
        return .init(width: self.bounds.width / CGFloat(imagesCount), height: self.bounds.width / CGFloat(imagesCount) )
     //   return .init(width: 100 , height: 100)
    }
    
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(contentText)
        addSubview(contentCollectionView)
        
        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentText)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentCollectionView)
        addConstrainsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstrainsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(\(self.bounds.width))]|", views: profileImageView, contentText, contentCollectionView)

    }
}

let photoCellID = "PhotoCellID"

class PhotoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "cyberpunk")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    func setupViews() {
        
        addSubview(imageView)
        addConstrainsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstrainsWithFormat(format: "V:|[v0]|", views: imageView)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}

class PhotoGridViewLayout: UICollectionViewLayout {

    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    // Хранит атрибуты для заданных индексов
    var columnsCount = 2                  // Количество столбцов
    var cellHeight: CGFloat = 128         // Высота ячейки
    private var totalCellsHeight: CGFloat = 0 // Хранит суммарную высоту всех ячеек
    
    override func prepare() {
       
        self.cacheAttributes = [:] // Инициализируем атрибуты
        
        // Проверяем наличие collectionView
        guard let collectionView = self.collectionView else { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        // Проверяем, что в секции есть хотя бы одна ячейка
        guard itemsCount > 0 else { return }
        
        let bigCellWidth = collectionView.frame.width
        let smallCellWidth = collectionView.frame.width / CGFloat(self.columnsCount)
        
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (index + 1) % (self.columnsCount + 1) == 0
            
            
            if isBigCell {
                attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: self.cellHeight)
                lastY += self.cellHeight
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: self.cellHeight)
                let isLastColumn = (index + 2) % (self.columnsCount + 1) == 0 || index == itemsCount - 1
                if isLastColumn {
                    lastX = 0
                    lastY += self.cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            
            cacheAttributes[indexPath] = attributes
            self.totalCellsHeight = lastY
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0,
                      height: self.totalCellsHeight)
    }


    
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
