//
//  NewsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 20.12.2020.
//

import UIKit

class NewsTableViewController: UITableViewController {

    var myNews = [News(logo: #imageLiteral(resourceName: "rZi7F9_vu-8"),
                       caption: "Пикабу",
                       date: "21 минута назад",
                       text:
                        """
                    В клане Дедов Морозов пополнение — вы. Работенка непростая, зато конкуренции не бывает. Берите ноги в руки и приступайте — за вас никто нашу игру никто проходить не будет!

                    specials.pikabu.ru/megafon/ded_moroz/

                    #партнерскийпост
                    """
                    , image: #imageLiteral(resourceName: "h4c7CTTavIo"), like: Like(userLikes: false, count: 31)),
                  
                  News(logo: #imageLiteral(resourceName: "-LGOrMnatj4"),
                       caption: "ТОПОР — Хранилище",
                       date: "сегодня в 9:23",
                       text: nil,
                       image: #imageLiteral(resourceName: "fgggPGl0zJI"),
                       like: Like(userLikes: true, count: 1916)),
                  
                  News(logo: #imageLiteral(resourceName: "i9FnKM0Gxt4"),
                       caption: "Подслушано Коломна",
                       date: "вчера в 19:17", text: """
                    Эти напaдки нa курящих ужe задoлбали. В миpe предостаточно вoнючих и резких запaхов, нaпример, некоторые курицы пoливаются с ног до голoвы духами, а потом заходят в лифт или маршрутку, и ничего, все молчат. А coceди порой готoвят такую мepзость, вонь от котopoй стoит нa весь дом. И что, вы идете к ним pугаться? Зато нa курящих тoлпами набeгают побздеть и выскaзать претензии
                    Анонимно
                    """,
                       image: nil,
                       like: Like(userLikes: false, count: 38))
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myNews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell
        else {return UITableViewCell()}
        
        cell.logoImage.image = myNews[indexPath.row].logo
        cell.captionLabel.text = myNews[indexPath.row].caption
        cell.dateLabel.text = myNews[indexPath.row].date
        
        //если есть текст в новости
        if let text = myNews[indexPath.row].text {
            //выводим
            cell.contentText.text = text
            //здесь констрейн по высоте не нужен, просто задаем в настройках лейбла lines = 0
        } else{
            //прячем ячейку с помощю constrain width = 0
            NSLayoutConstraint.activate([cell.contentText.heightAnchor.constraint(equalToConstant: 0) ])
        }
        
        //если есть в новости картинка
        if let image = myNews[indexPath.row].image {
            //выводим
            cell.contentImage.image = image
            //вычисляем коэффициент
            let imageCrop = image.getCropRatio()
            //высоту картинки чтобы было в полную ширину
            let cropHeight = tableView.frame.width / imageCrop
            // задаем высоту
            NSLayoutConstraint.activate([cell.contentImage.heightAnchor.constraint(equalToConstant: cropHeight) ])
        } else {
            //прячем ячейку с помощю constrain width = 0
            NSLayoutConstraint.activate([cell.contentImage.heightAnchor.constraint(equalToConstant: 0) ])
        }
    
        cell.likeControl.isLiked = myNews[indexPath.row].like.userLikes
        cell.likeControl.likesCount = myNews[indexPath.row].like.count
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        return  CGFloat( self.size.width / self.size.height )
    }
}
