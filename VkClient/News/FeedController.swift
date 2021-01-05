//
//  FeedController.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.01.2021.
//

import UIKit

let cellId = "cellId"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myNews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        cell.profileImageView.image = myNews[indexPath.item].logo
        cell.nameLabel.setAttributedText(text: myNews[indexPath.item].caption, subtext: myNews[indexPath.item].date)
        if let text = myNews[indexPath.row].text {
            cell.contentText.text = text
        }
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 400)
    }
}

 //ячейка новостей
class FeedCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        contentImagesGrid.delegate = self
        contentImagesGrid.dataSource = self
        contentImagesGrid.register(PhotoGridCell.self, forCellWithReuseIdentifier: photoGridCellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel = UILabel()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let contentText: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let contentImagesGrid: UICollectionView = {
      //  layout.scrollDirection = .horizontal; //set scroll direction to horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: PhotoGridViewLayout())
        cv.backgroundColor = .blue
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv;
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: photoGridCellID, for: indexPath) as! PhotoGridCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: self.bounds.width, height: 200)
    }
    
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(contentText)
        addSubview(contentImagesGrid)
        
        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentText)
        addConstrainsWithFormat(format: "H:|-4-[v0]-4-|", views: contentImagesGrid)
        addConstrainsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        addConstrainsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2]|", views: profileImageView, contentText, contentImagesGrid)

    }
}

let photoGridCellID = "photoGridCellID"

class PhotoGridCell: UICollectionViewCell {
    
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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func setupViews() {
        
        addSubview(imageView)
        addConstrainsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstrainsWithFormat(format: "V:|[v0]|", views: imageView)
        
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
