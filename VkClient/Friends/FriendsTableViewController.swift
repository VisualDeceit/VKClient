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
    
    var friendsLastNameTitles = [String]()
    var friendsDictionary = [String: [User]]()
    
    
    func update(indexPhoto: Int, like: Like) {
        //friends[tableView.indexPathForSelectedRow!.row].album![indexPhoto].like = like
        let lastNameKey = friendsLastNameTitles[tableView.indexPathForSelectedRow!.section]
        if var userValues = friendsDictionary[lastNameKey] {
            userValues[tableView.indexPathForSelectedRow!.row].album![indexPhoto].like = like
            friendsDictionary[lastNameKey] = userValues
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for user in friends {
            let lastNameKey = String(user.last_name.prefix(1))
            if var userValues = friendsDictionary[lastNameKey] {
                userValues.append(user)
                friendsDictionary[lastNameKey] = userValues
            } else {
                friendsDictionary[lastNameKey] = [user]
            }
        }
        
        friendsLastNameTitles = [String](friendsDictionary.keys)
        friendsLastNameTitles = friendsLastNameTitles.sorted(by: <)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsLastNameTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let lastNameKey = friendsLastNameTitles[section]
        if let userValues = friendsDictionary[lastNameKey] {
            return userValues.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        
        let lastNameKey = friendsLastNameTitles[indexPath.section]
        if let userValues = friendsDictionary[lastNameKey] {
            cell.friendName.text = "\(userValues[indexPath.row].first_name) \(userValues[indexPath.row].last_name)"
            cell.friendAvatar.logoView.image = #imageLiteral(resourceName: "camera_50")
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsLastNameTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
       return friendsLastNameTitles
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showUserPhotos",
              let controller = segue.destination as? PhotoCollectionViewController else { return }
        
        let selectedUser = tableView.indexPathForSelectedRow
        let lastNameKey = friendsLastNameTitles[selectedUser!.section]
        if let userValues = friendsDictionary[lastNameKey] {
            controller.user = userValues[selectedUser!.row]
        }
        controller.delegate = self // подписали на делегат

    }
    
}
