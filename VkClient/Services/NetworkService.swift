//
//  NetworkService.swift
//  VkClient
//
//  Created by Alexander Fomin on 17.01.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkServices {
    
    let vAPI = "5.126"
    
//получение списка друзей
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
                        DispatchQueue.main.async {
                            try? RealmService.save(items: friends)
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
}
