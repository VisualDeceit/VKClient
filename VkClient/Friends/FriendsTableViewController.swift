//
//  FriendsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit


class FriendsTableViewController: UITableViewController {
      
    var friends = [User]()
    
    func fillData(){
        
        func randomAlbum() -> [Photo] {
            var photo = Photo(img: UIImage(), like: Like(userLikes: false, count: 0))
            var album = [Photo]()
            for _ in 1...Int.random(in: 1..<2){
                let url = URL(string: "https://picsum.photos/150")
                let data = try? Data(contentsOf: url!)
                let img = UIImage(data: data!)
                photo.img = img!
                photo.like.count = Int.random(in: 0..<50)
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
         
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fillData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.friendName.text = "\(friends[indexPath.row].first_name) \(friends[indexPath.row].last_name)"
        
        cell.friendAvatar.logoView.image = #imageLiteral(resourceName: "camera_50")
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showUserPhotos",
              let controller = segue.destination as? PhotoCollectionViewController else { return }
        
        let selectedUser = tableView.indexPathForSelectedRow
        controller.user = friends[selectedUser!.row]

    }
    
  

}
