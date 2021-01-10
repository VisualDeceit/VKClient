//
//  FeedController.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.01.2021.
//

import UIKit



class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsFeed.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell =  collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
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
