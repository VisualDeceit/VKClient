//
//  NewsPostViewModelFactory.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.04.2021.
//

import UIKit

class NewsPostViewModelFactory {
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = DateFormatter.Style.short
        df.dateStyle = DateFormatter.Style.short
        df.timeZone = .current
        return df
    }()
    
    let imageGroup = DispatchGroup()
    var newsPostViewMode = [NewsPostViewModel]()
    
    let dispatchGroup = DispatchGroup()
    let dispatchQueue = DispatchQueue(label: "com.VkClient.NewsPostViewModelFactory.constructViewModels")
    let dispatchSemaphore = DispatchSemaphore(value: 0)
    
    func constructViewModels(from news: [NewsPost], onCompletion: @escaping ([NewsPostViewModel]) -> () ) {
        
        dispatchQueue.async {
            
            news.forEach {
                self.dispatchGroup.enter()
                self.viewModel(from: $0) {(viewMode) in
                    self.newsPostViewMode.append(viewMode)
                    self.dispatchSemaphore.signal()
                    self.dispatchGroup.leave()
                }
                self.dispatchSemaphore.wait()
            }
        }
        
        dispatchGroup.notify(queue: dispatchQueue) {
            DispatchQueue.main.async {
                onCompletion(self.newsPostViewMode)
                self.newsPostViewMode.removeAll()
            }
        }
    }
    
    private func viewModel(from newsPost: NewsPost, onCompletion: @escaping (NewsPostViewModel) -> ()) {
        
        var contentAttach = [ViewModelAttachment]()
        var iconImage = UIImage()
        
        let caption = newsPost.name
        let date = Date(timeIntervalSince1970: newsPost.date)
        let dateText =  NewsPostViewModelFactory.dateFormatter.string(from: date)
        let dateInt = newsPost.date
        let contentText = newsPost.text
        let likesCount = newsPost.likesCount
        let isLiked = newsPost.isLiked
        let repostsCount = postParamToString(countInt: newsPost.repostsCount)
        let viewsCount = postParamToString(countInt: newsPost.viewsCount)
        let commentsCount = postParamToString(countInt: newsPost.commentsCount)
        
        //есть содержимое
        if let attachments = newsPost.attachments {
            for i in 0..<attachments.count where i < 4 {
                //  эти пока обрабатываем
                guard attachments[i].type == "photo" || attachments[i].type == "video" || attachments[i].type == "link" else { continue }

                //создаем очередь
                self.imageGroup.enter()
                if let url = URL(string: attachments[i].url) {
                    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
                    URLSession.shared.dataTask(with: request) { (data, _, _) in
                        if let tempData = data,
                           let image = UIImage(data: tempData) {
                                contentAttach.append(ViewModelAttachment(image: image, ratio: attachments[i].ratio))
                        }
                        self.imageGroup.leave()
                    }.resume()
                }
            }
        }
        
        //создаем очередь
        self.imageGroup.enter()
        if let url = URL(string: newsPost.avatarUrl) {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            URLSession.shared.dataTask(with: request) { (data, _, _) in
                if let tempData = data,
                   let image = UIImage(data: tempData) {
                    iconImage = image
                }
                self.imageGroup.leave()
            }.resume()
        }
        
        //все задания из группы закончились
        imageGroup.notify(queue: DispatchQueue.global()) {
            let viewModel =  NewsPostViewModel(iconImage: iconImage, caption: caption, dateText: dateText, dateInt: dateInt, contentText: contentText, likesCount: likesCount, isLiked: isLiked, repostsCount: repostsCount, viewsCount: viewsCount, commentsCount: commentsCount, attachments: contentAttach)
            onCompletion(viewModel)
        }
    }

    private func postParamToString(countInt: Int?) -> String {
        let count = countInt ?? 0
        if count < 1000 {
            return String(count)
        } else {
            return String(format: "%.1fk", Double(count)/1000.0)
        }
    }
}
