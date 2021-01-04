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

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: view.frame.width, height: 60)
    }
}


class FeedCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
       // label.setAttributedText(text: "Main text", subtext: "Sub text")
//        label.text = "Simple name"
//        let attributedText = NSMutableAttributedString(string: label.text!, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
//        attributedText.append(NSMutableAttributedString(string: "\nсегодня в 9:23", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor(white: 0.6, alpha: 1)]))
//        label.attributedText = attributedText
        return label
    }()
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    func setupViews() {
        backgroundColor = .white
        
        addSubview(nameLabel)
        addSubview(profileImageView)
        
        addConstrainsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstrainsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstrainsWithFormat(format: "V:|-8-[v0(44)]-8-|", views: profileImageView)

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
