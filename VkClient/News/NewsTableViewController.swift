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
                       , image: #imageLiteral(resourceName: "h4c7CTTavIo"),
                       like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
                  
                  News(logo: #imageLiteral(resourceName: "-LGOrMnatj4"),
                       caption: "ТОПОР — Хранилище",
                       date: "сегодня в 9:23",
                       text: nil,
                       image: #imageLiteral(resourceName: "cyberpunk"),
                       like: Like(isLiked: true, totalCount: Int.random(in: 1...1000))),
                  
                  News(logo: #imageLiteral(resourceName: "i9FnKM0Gxt4"),
                       caption: "Подслушано Коломна",
                       date: "вчера в 19:17", text: """
                    Эти напaдки нa курящих ужe задoлбали. В миpe предостаточно вoнючих и резких запaхов, нaпример, некоторые курицы пoливаются с ног до голoвы духами, а потом заходят в лифт или маршрутку, и ничего, все молчат. А coceди порой готoвят такую мepзость, вонь от котopoй стoит нa весь дом. И что, вы идете к ним pугаться? Зато нa курящих тoлпами набeгают побздеть и выскaзать претензии
                    Анонимно
                    """,
                       image: nil,
                       like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
                 
                  News(logo: #imageLiteral(resourceName: "rZi7F9_vu-8"),
                       caption: "Пикабу",
                       date: "2 часа назад",
                       text:
                        """
                                  Когда люди слышат слово «пират», то им практически тут же в голову приходит знаменитый образ Джонни Деппа, что сыграл Джека Воробья. Но вот реальность куда более прозаична и сурова и пираты водились не только в Карибском бассейне, в Средиземноморье тоже умудрились достаточно знатно покуролесить, Картавых не даст соврать...

                                  Длиннопост от Дмитрия Мельничука из команды Cat.Cat: pikabu.ru/link/b7907232
                                  """
                       , image: #imageLiteral(resourceName: "1556962064181431984"),
                       like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
                  
                  News(logo: #imageLiteral(resourceName: "-LGOrMnatj4"),
                       caption: "ТОПОР — Хранилище",
                       date: "сегодня в 9:23",
                       text: """
Шнуров ответил на критику своего хуевого вопроса Путину
""",
                       image: #imageLiteral(resourceName: "0MzQi1AE9DA"),
                       like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
                  
                  News(logo: #imageLiteral(resourceName: "i9FnKM0Gxt4"),
                       caption: "Подслушано Коломна",
                       date: "сегодня в 13:08",
                       text: """
                                  Чтoбы не рубить и не пoкупать кaждый гoд елку, растет отличнo дома, продaeтся сейчac многo гдe комнатнaя ёлкa 😉
                                  """,
                       image: #imageLiteral(resourceName: "rXTwsPh_bAs"),
                       like: Like(isLiked: false, totalCount: Int.random(in: 1...1000)))
                  
    ]
    
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
            cell.contentText.text = text
            //здесь констрейн по высоте не нужен, просто задаем в настройках лейбла lines = 0
        }
        
        //если есть в новости картинка
        if let image = myNews[indexPath.row].image {
            //выводим
            cell.contentImage.image = image
            //высоту картинки чтобы было в полную ширину
            let ratio = image.getCropRatio()
            let cropHeight = tableView.frame.width / ratio
            // задаем высоту
            cell.imageViewHeight.constant = cropHeight
        } else {
            cell.imageViewHeight.constant = 0
        }
    
        cell.likeControl.isLiked = myNews[indexPath.row].like.isLiked
        cell.likeControl.totalCount = myNews[indexPath.row].like.totalCount
        let viewCount = "\(Int.random(in: 1..<10000))"//temp data
        cell.viewsNumber.text =  viewCount.count < 4 ? viewCount : String(format: "%.1fk", Float(viewCount)!/1000.0)
        
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

extension UIImage {
    func getCropRatio() -> CGFloat {
        return  CGFloat( self.size.width / self.size.height )
    }
}
