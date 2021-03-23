//
//  NetworkService.swift
//  VkClient
//
//  Created by Alexander Fomin on 17.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

public struct NewsFeedType: RawRepresentable {
    public static let post = NewsFeedType(rawValue: "post")
    public static let photo = NewsFeedType(rawValue: "photo")
   
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

class NetworkServices {
    
    private let vAPI = "5.130"
    
//получение списка друзей
    ///обычный
    func getUserFriends() {
        //собираем url
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/friends.get"
            url.queryItems = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: vAPI),
                              URLQueryItem(name: "fields", value: "photo_50")]
            return url
        }()
        
        //создаем сессию
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //проверяем url
        if let url  = urlComponent.url {
            //создаем задание
            let task = session.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    do {
                        let json = try JSON(data: data)
                        let items = json["response"]["items"].arrayValue
                        let friends = items.map { User($0) }
                        
                        // удаляем старых друзей
                        let ids = friends.map { $0.id}
                        let objectsToDelete = try RealmService.load(typeOf: User.self).filter("NOT id IN %@", ids)
                        try RealmService.delete(object: objectsToDelete)
      
                        //сохранение данных в Realm
                            try? RealmService.save(items: friends)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    ///promisKit
    func getUserFriendsPromise() -> Promise<[User]> {
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/friends.get"
            url.queryItems = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: vAPI),
                              URLQueryItem(name: "fields", value: "photo_50")]
            return url
        }()

        return Promise { seal in
            if let url  = urlComponent.url {
                URLSession.shared.dataTask(with: url) { (data, _, _) in
                    if let data = data {
                        do {
                            let json = try JSON(data: data)
                            let items = json["response"]["items"].arrayValue
                            let friends = items.map { User($0) }
                            seal.fulfill(friends)
                        }
                        catch {
                            seal.reject(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
    //получение всех фото
    func getPhotos(for user: User) {
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/photos.getAll"
            url.queryItems = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: vAPI),
                              URLQueryItem(name: "owner_id", value: String(user.id)),
                              URLQueryItem(name: "extended", value: "1"),
                              URLQueryItem(name: "count", value: "200"),]
            return url
        }()
        
        //создаем сессию
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //проверяем url
        if let url  = urlComponent.url {
            //создаем запрос
            let request = URLRequest(url: url)
            //создаем задание
            let task = session.dataTask(with: request) { (data, _, _) in
                if let data = data {
                    do {
                        let userPhoto = try JSONDecoder().decode(UserPhotoResponse.self, from: data).items
                        //сохранение данных в Realm
                        DispatchQueue.main.async {
                            userPhoto.forEach{$0.owner = user}
                            try? RealmService.save(items: userPhoto)
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
//получение списка групп пользователя через  Alamofire
    func getUserGroups() {
        let host = "https://api.vk.com"
        let path = "/method/groups.get"
        let parameters: Parameters = [
            "access_token": Session.shared.token!,
            "v": vAPI,
            "extended": "1"
        ]
        AF.request(host+path,
                   method: .get,
                   parameters: parameters).responseData { (response) in
                    switch response.result {
                    case .success(let data):
                        do {
                            let groups = try JSONDecoder().decode(GroupResponse.self, from: data).items
                            
                            // удаляем старых друзей
                            let ids = groups.map { $0.id}
                            let objectsToDelete = try RealmService.load(typeOf: Group.self).filter("NOT id IN %@", ids)
                            try RealmService.delete(object: objectsToDelete)
                            
                            //сохранение данных в Realm
                            try? RealmService.save(items: groups)
                        }
                        catch {
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                    }
                   }
    }
    
    //поиск группы
    func searchGroups(by caption: String) {
        let host = "https://api.vk.com"
        let path = "/method/groups.search"
        let parameters: Parameters = [
            "access_token": Session.shared.token!,
            "v": vAPI,
            "q": caption
        ]
            AF.request(host+path,
                       method: .get,
                       parameters: parameters).responseJSON { (json) in
                        
                       }
    }
    
    // новости типа post
    func getNewsFeed(type: NewsFeedType, startTime: Int, completion: @escaping ([NewsPost]) ->()) {
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/newsfeed.get"
            url.queryItems = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: vAPI),
                              URLQueryItem(name: "filters", value: type.rawValue),
                              URLQueryItem(name: "count", value: "20"),
                              URLQueryItem(name: "max_photos", value: "4"),
                              URLQueryItem(name: "start_time", value: "\(startTime)"),
            ]
            return url
        }()
        
        //создаем сессию
        let session = URLSession(configuration: URLSessionConfiguration.default)
        //проверяем url
        if let url  = urlComponent.url {
            //создаем запрос
            let request = URLRequest(url: url)
            //создаем задание
            let task = session.dataTask(with: request) { (data, _, _) in
                if let data = data {
                    do {
                        let newsPosts = try JSONDecoder().decode(NewsPostResponse.self, from: data).items
                        let groups = try JSONDecoder().decode(NewsPostResponse.self, from: data).gpoups
                        let profiles = try JSONDecoder().decode(NewsPostResponse.self, from: data).profiles
                        newsPosts.forEach { news in
                            if news.sourceId < 0 {
                                //groups
                               let group =  groups.first { (element) -> Bool in
                                element.id == abs(news.sourceId)
                                }
                                news.name = group?.name ?? "Group name"
                                news.avatarUrl = group?.photoURL ?? "https://vk.com/images/camera_50.png"
                            } else {
                                //profiles
                                let profile =  profiles.first { (element) -> Bool in
                                    element.id == abs(news.sourceId)
                                 }
                                 news.name = profile?.name ?? "Profile name"
                                 news.avatarUrl = profile?.photoURL ?? "https://vk.com/images/camera_50.png"
                            }
                        }
                        completion(newsPosts)
                    }
                    catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
}
