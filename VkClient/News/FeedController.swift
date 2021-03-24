//
//  FeedController.swift
//  VkClient
//
//  Created by Alexander Fomin on 03.01.2021.
//

import UIKit

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var newsPosts = [NewsPost]()
    var refresher: UIRefreshControl!
    let networkService = NetworkServices()
    var nextFrom = ""
    var isLoading = false
    var canShowMoreButton = false

    
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
        newsRequest()
        
        //MARK: - Pull-to-refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Fetching data...")
        refresher.addTarget(self, action: #selector(newsRequest), for: .valueChanged)
        collectionView.addSubview(refresher)
        
        collectionView.prefetchDataSource = self
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
            canShowMoreButton = textHeight > 200 ? true : false
            if canShowMoreButton {
                textHeight = 200
            }
        }
        
        var imagesHeight: CGFloat = -8
        let showMoreButton: CGFloat = canShowMoreButton ? 14 : 0
        
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
        
        return .init(width: view.frame.width, height: 60 + textHeight + showMoreButton + imagesHeight + 8 + 1 + 8 + 30 )
    }
    
    func getStringDate(from value: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(value))
        return dateFormatter.string(from: date)
    }
    
    //загрузка данных из сети
    @objc
    func newsRequest() {
        let requestTime = newsPosts.count == 0 ? 0 : (newsPosts.first?.date ?? 0)
        networkService.getNewsFeed(type: .post, startTime: requestTime + 1) { [weak self] (news, nextFrom) in
            if let self = self {
                DispatchQueue.main.async {
                    self.refresher.endRefreshing()
                }

                if let nextFrom = nextFrom, self.nextFrom == "" {
                    self.nextFrom = nextFrom
                }
                guard news.count > 0 else { return }
                //новости добавляем в начало
                self.newsPosts = news + self.newsPosts
                //создаем индексы для вставки
                let indexPath = (0..<news.count).map {IndexPath(row: $0, section: 0)}
                DispatchQueue.main.async {
                    self.collectionView.insertItems(at: indexPath)
                }
                
            }
        }
    }
    
}

//MARK: - Паттерн Infinite Scrolling

extension FeedController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxItem = indexPaths.max()?.item else {   return }
        if  maxItem > newsPosts.count - 5, !isLoading {
            isLoading = true
            networkService.getNewsFeed(type: .post, startFrom: nextFrom) { [weak self] (news, nextFrom) in
                if let self = self {
                    if let nextFrom = nextFrom {
                        self.nextFrom = nextFrom
                    }
                    //создаем индексы для вставки
                    let indexPath = (self.newsPosts.count..<self.newsPosts.count + news.count).map {IndexPath(row: $0, section: 0)}
                    //новости добавляем в конец
                    self.newsPosts.append(contentsOf: news)
                    DispatchQueue.main.async {
                        self.collectionView.insertItems(at: indexPath)
                        self.isLoading = false
                    }
                    
                }
            }
            
        }
    }
    
}
