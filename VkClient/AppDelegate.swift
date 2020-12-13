//
//  AppDelegate.swift
//  VkClient
//
//  Created by Alexander Fomin on 02.12.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    //MARK:- Тестовые данные
    func fillUsersData() {
    
        func randomAlbum() -> [Photo] {
            var photo = Photo(img: UIImage(), likes: Likes(user_likes: 0, count: 0))
            var album = [Photo]()
            for _ in 1...Int.random(in: 1..<5){
                let url = URL(string: "https://picsum.photos/150")
                let data = try? Data(contentsOf: url!)
                let img = UIImage(data: data!)
                photo.img = img!
                photo.likes.count = Int.random(in: 0..<50)
                album.append(photo)
            }
            return album
        }
        
        friends.append(User(first_name: "Александр", last_name: "Фомин", album: randomAlbum()))
        friends.append(User(first_name: "Хасан", last_name: "Сатийаджиев", album: randomAlbum()))
        friends.append(User(first_name: "NIKOLAI", last_name: "BORISOV", album: randomAlbum()))
        friends.append(User(first_name: "Виталий", last_name: "Степушин", album: randomAlbum()))
        friends.append(User(first_name: "Василий", last_name: "Князев", album: randomAlbum()))
        friends.append(User(first_name: "Mikhail", last_name: "Gereev", album: randomAlbum()))
        friends.append(User(first_name: "Айрат", last_name: "Бариев", album: randomAlbum()))
        friends.append(User(first_name: "Юрий", last_name: "Фёдоров", album: randomAlbum()))
        friends.append(User(first_name: "Анна", last_name: "Панфилова", album: randomAlbum()))
        friends.append(User(first_name: "Виктор", last_name: "Гарицкий", album: randomAlbum()))
        friends.append(User(first_name: "Юрий", last_name: "Егоров", album: randomAlbum()))
        friends.append(User(first_name: "Сергей", last_name: "Нелюбин", album: randomAlbum()))
        

        allGroups.append(Group(name: "Пикабу", screen_name: "pikabu", logo: #imageLiteral(resourceName: "rZi7F9_vu-8") ))
        allGroups.append(Group(name: "ТОПОР — Хранилище", screen_name: "toportg", logo: #imageLiteral(resourceName: "-LGOrMnatj4")))
        allGroups.append(Group(name: "Подслушано Коломна", screen_name: "kolomna_tut", logo: #imageLiteral(resourceName: "i9FnKM0Gxt4")))
        userGroups.append(Group(name: "Подслушано Коломна", screen_name: "kolomna_tut", logo: #imageLiteral(resourceName: "i9FnKM0Gxt4")))
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        fillUsersData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

