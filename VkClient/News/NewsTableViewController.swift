//
//  NewsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 20.12.2020.
//

import UIKit

class NewsTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell
        else {return UITableViewCell()}
        
//        cell.logoImage.logoView.image = myNews[indexPath.row].logo
//        cell.captionLabel.text = myNews[indexPath.row].caption
//        cell.dateLabel.text = myNews[indexPath.row].date
//     
//        //если есть текст в новости
//        if let text = myNews[indexPath.row].text {
//            cell.contentText.text = text
//            //здесь констрейн по высоте не нужен, просто задаем в настройках лейбла lines = 0
//        }
//        
//        //если есть в новости картинка
//        if let image = myNews[indexPath.row].image {
//            //выводим
//            cell.contentImage.image = image
//            //высоту картинки чтобы было в полную ширину
//            let ratio = image.getCropRatio()
//            let cropHeight = tableView.frame.width / ratio
//            // задаем высоту
//            cell.imageViewHeight.constant = cropHeight
//        } else {
//            cell.imageViewHeight.constant = 0
//        }
//    
//        cell.likeControl.isLiked = myNews[indexPath.row].like.isLiked
//        cell.likeControl.totalCount = myNews[indexPath.row].like.totalCount
//        let viewCount = "\(Int.random(in: 1..<10000))"//temp data
//        cell.viewsNumber.text =  viewCount.count < 4 ? viewCount : String(format: "%.1fk", Float(viewCount)!/1000.0)
//        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //так как высота картинки вычисляется только в cellForRowAt,
        //то необходимо принудительно дернуть reloadData() при смене ориентации, иначе останется прежний разме
        //картинки
        tableView.reloadData()
    }
    
}
