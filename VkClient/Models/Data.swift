//
//  Data.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

struct User {
    let id: Int = 0
    let first_name: String
    let last_name: String
    var album: [Photo]?

    init(first_name: String, last_name: String) {
        self.first_name = first_name
        self.last_name = last_name
        self.album = []
        
        for _ in 1..<Int.random(in: 10...20) {
            self.album?.append(Photo(like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))))
        }

    }

    init(first_name: String, last_name: String, album: [Photo]?) {
        self.first_name = first_name
        self.last_name = last_name
        self.album = album
    }
}

struct Photo {
    var imageURL:  String = "https://picsum.photos/300"
    var imageData: UIImage?
    var like: Like
}

struct Like {
    var isLiked: Bool = false
    var totalCount: Int = 0
}

struct News {
    var logo: UIImage?
    var caption: String = ""
    var date: String = ""
    var text: String?
    var image: UIImage?
    var like: Like
}


struct Post {
    var logo: UIImage?
    var caption: String = ""
    var date: String = ""
    var text: String?
    var image: [UIImage]?
    var like: Like
    var imagesCount: Int  {
        return image?.count ?? 0
    }
}

var newsFeed = [Post(logo: #imageLiteral(resourceName: "rZi7F9_vu-8"),
                   caption: "Пикабу",
                   date: "21 минута назад",
                   text:
                    """
                В клане Дедов Морозов пополнение — вы. Работенка непростая, зато конкуренции не бывает. Берите ноги в руки и приступайте — за вас никто нашу игру никто проходить не будет!

                specials.pikabu.ru/megafon/ded_moroz/

                #партнерскийпост
                """,
                   image: [#imageLiteral(resourceName: "h4c7CTTavIo")],
                   like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
              
                Post(logo: #imageLiteral(resourceName: "-LGOrMnatj4"),
                   caption: "ТОПОР — Хранилище",
                   date: "сегодня в 9:23",
                   text: nil,
                   image: [#imageLiteral(resourceName: "cyberpunk")],
                   like: Like(isLiked: true, totalCount: Int.random(in: 1...1000))),
              
                Post(logo: #imageLiteral(resourceName: "i9FnKM0Gxt4"),
                   caption: "Подслушано Коломна",
                   date: "вчера в 19:17", text: """
                Эти напaдки нa курящих ужe задoлбали. В миpe предостаточно вoнючих и резких запaхов, нaпример, некоторые курицы пoливаются с ног до голoвы духами, а потом заходят в лифт или маршрутку, и ничего, все молчат. А coceди порой готoвят такую мepзость, вонь от котopoй стoит нa весь дом. И что, вы идете к ним pугаться? Зато нa курящих тoлпами набeгают побздеть и выскaзать претензии
                Анонимно
                """,
                   image: nil,
                   like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
             
                Post(logo: #imageLiteral(resourceName: "rZi7F9_vu-8"),
                   caption: "Пикабу",
                   date: "2 часа назад",
                   text:
                    """
                              Когда люди слышат слово «пират», то им практически тут же в голову приходит знаменитый образ Джонни Деппа, что сыграл Джека Воробья. Но вот реальность куда более прозаична и сурова и пираты водились не только в Карибском бассейне, в Средиземноморье тоже умудрились достаточно знатно покуролесить, Картавых не даст соврать...

                              Длиннопост от Дмитрия Мельничука из команды Cat.Cat: pikabu.ru/link/b7907232
                              """
                   , image:  [#imageLiteral(resourceName: "cyberpunk"),#imageLiteral(resourceName: "1556962064181431984")],
                   like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
              
                Post(logo: #imageLiteral(resourceName: "-LGOrMnatj4"),
                   caption: "ТОПОР — Хранилище",
                   date: "сегодня в 9:23",
                   text: """
Шнуров ответил на критику своего хуевого вопроса Путину
""",
                   image:  [#imageLiteral(resourceName: "rXTwsPh_bAs"),#imageLiteral(resourceName: "1556962064181431984"),#imageLiteral(resourceName: "cyberpunk")],
                   like: Like(isLiked: false, totalCount: Int.random(in: 1...1000))),
              
                Post(logo: #imageLiteral(resourceName: "i9FnKM0Gxt4"),
                   caption: "Подслушано Коломна",
                   date: "сегодня в 13:08",
                   text: """
                              Чтoбы не рубить и не пoкупать кaждый гoд елку, растет отличнo дома, продaeтся сейчac многo гдe комнатнaя ёлкa 😉
                              """,
                   image: [#imageLiteral(resourceName: "1556962064181431984"),#imageLiteral(resourceName: "1556962064181431984"),#imageLiteral(resourceName: "cyberpunk"),#imageLiteral(resourceName: "0MzQi1AE9DA")],
                   like: Like(isLiked: false, totalCount: Int.random(in: 1...1000)))
              
]




