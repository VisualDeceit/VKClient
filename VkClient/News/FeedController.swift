//
//  FeedController.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.01.2021.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var newsPosts = [NewsPost]()
    
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
        feedCell.newsPost = newsPosts[indexPath.item]
        return feedCell
    }
    
    
    //Feed cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var textHeight: CGFloat = 0
        
        //MARK: - Calculate text height
        if !newsPosts[indexPath.row].text.isEmpty {
            let contentText = newsPosts[indexPath.row].text
            let rect = NSString(string: contentText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)], context: nil)
            
            textHeight = rect.height + 24
        }
        
        //let imagesHeight = calculateImageHeight(images: newsFeed[indexPath.item].image, width: view.frame.width)
        let imagesHeight = CGFloat.zero
        return .init(width: view.frame.width, height: 60 + textHeight + imagesHeight + 21 + 30 )
    }
}
