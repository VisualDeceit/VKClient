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
    
    var attachURL: [URL]?
    
    func constructViewModels(from news: [NewsPost]) -> [NewsPostViewModel] {
        var newsPostViewMode = [NewsPostViewModel]()
        news.forEach {
            self.viewModel(from: $0) {(viewMode) in
                newsPostViewMode.append(viewMode)
            }
        }
        return newsPostViewMode
    }
    
    let imageGroup = DispatchGroup()
    
    private func viewModel(from newsPost: NewsPost, handler: @escaping (NewsPostViewModel) -> ()) {
        
        var contentAttach = [ViewModelAttachment]()
        var iconImage = UIImage()
        
        let caption = newsPost.name
        let date = Date(timeIntervalSince1970: newsPost.date)
        let dateText =  NewsPostViewModelFactory.dateFormatter.string(from: date)
        let contentText = newsPost.text
        let likesCount = newsPost.likesCount
        let isLiked = newsPost.isLiked
        let repostsCount = postParamToString(countInt: newsPost.repostsCount)
        let viewsCount = postParamToString(countInt: newsPost.viewsCount)
        let commentsCount = postParamToString(countInt: newsPost.commentsCount)
        
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
                self.imageGroup.enter()
                if let url = URL(string: attachments[i].url) {
                    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
                    URLSession.shared.dataTask(with: request) { (data, _, _) in
                        if let tempData = data,
                           let image = UIImage(data: tempData) {
                            //если это запрашиваемый url
                            if self.attachURL!.contains(url) {
                                contentAttach.append(ViewModelAttachment(image: image, ratio: attachments[i].ratio))
                            }
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
            let viewModel =  NewsPostViewModel(iconImage: iconImage, caption: caption, date: dateText, text: contentText, likesCount: likesCount, isLiked: isLiked, repostsCount: repostsCount, viewsCount: viewsCount, commentsCount: commentsCount, attachments: contentAttach)
           handler(viewModel)
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
