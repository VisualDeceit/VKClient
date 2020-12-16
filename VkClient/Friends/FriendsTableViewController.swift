//
//  FriendsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

protocol FriendsTableViewControllerDelegate: class {
    func update(indexPhoto: Int, like: Like)
}

class FriendsTableViewController: UITableViewController, FriendsTableViewControllerDelegate {
    
    var friends = [
        User(first_name: "Александр", last_name: "Фомин"),
        User(first_name: "Хасан", last_name: "Сатийаджиев"),
        User(first_name: "NIKOLAI", last_name: "BORISOV"),
        User(first_name: "Виталий", last_name: "Степушин"),
        User(first_name: "Василий", last_name: "Князев"),
        User(first_name: "Mikhail", last_name: "Gereev"),
        User(first_name: "Айрат", last_name: "Бариев"),
        User(first_name: "Юрий", last_name: "Фёдоров"),
        User(first_name: "Анна", last_name: "Панфилова"),
        User(first_name: "Виктор", last_name: "Гарицкий"),
        User(first_name: "Юрий", last_name: "Егоров"),
        User(first_name: "Сергей", last_name: "Нелюбин"),
    ]
    
    func update(indexPhoto: Int, like: Like) {
        friends[tableView.indexPathForSelectedRow!.row].album![indexPhoto].like = like
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
        controller.delegate = self // подписали на делегат

    }
    
}
