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
    func getUserFriends(closure: @escaping () -> Void) {
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
                        //сохранение данных в Realm
                        DispatchQueue.main.async {
                            try? RealmService.save(items: friends)
                        }
                        closure()
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
    func getPhotos(for userID: Int, closure: @escaping ([UserPhoto]) -> () ) {
        let urlComponent: URLComponents = {
            var url = URLComponents()
            url.scheme = "https"
            url.host = "api.vk.com"
            url.path = "/method/photos.getAll"
            url.queryItems = [URLQueryItem(name: "access_token", value: Session.shared.token),
                              URLQueryItem(name: "v", value: vAPI),
                              URLQueryItem(name: "owner_id", value: String(userID)),
                              URLQueryItem(name: "extended", value: "1")]
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
                        closure(userPhoto)
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
    func getUserGroups(closure: @escaping () -> ()) {
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
                            //сохранение данных в Realm
                            try? RealmService.save(items: groups)
                            closure()
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
