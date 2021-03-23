//
//  FeedController.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.01.2021.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var newsPosts = [NewsPost]()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = DateFormatter.Style.short //Set time style
        df.dateStyle = DateFormatter.Style.short //Set date style
        df.timeZone = .current
        return df
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.identifier)
        collectionView.alwaysBounceVertical = true
        
        //загрузка данных из сети
        let networkService = NetworkServices()
        networkService.getNewsFeed(type: .post) { [weak self] news in
            self?.newsPosts = news
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsPosts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell =  collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
        feedCell.stringDate = getStringDate(from: newsPosts[indexPath.item].date)
        feedCell.newsPost = newsPosts[indexPath.item]
        return feedCell
    }
    
    
    //Feed cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var textHeight: CGFloat = 0
        
        //MARK: - Calculate text height
        if !newsPosts[indexPath.row].text.isEmpty {
            let contentText = newsPosts[indexPath.row].text
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = .byWordWrapping
            let textBlock = CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude)
            let rect = contentText.boundingRect(with: textBlock, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.paragraphStyle: style], context: nil)
            textHeight = rect.height + 8
        }
        
        var imagesHeight: CGFloat = -8
        if let count = newsPosts[indexPath.item].attachments?.count {
            switch count {
            case 1:
                if let ratio = newsPosts[indexPath.item].attachments?.first?.ratio, ratio != 0  {
                    imagesHeight =  view.frame.width / ratio
                } else {
                    imagesHeight = -8
                }
            case 2...:
                imagesHeight =  view.frame.width
            default:
                ()
            }
    }
        
        return .init(width: view.frame.width, height: 60 + textHeight + imagesHeight + 8 + 1 + 8 + 30 )
    }
    
    func getStringDate(from value: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(value))
        return dateFormatter.string(from: date)
    }
    

}
