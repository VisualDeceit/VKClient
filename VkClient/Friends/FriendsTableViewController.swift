//
//  FriendsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit


class FriendsTableViewController: UITableViewController {
    
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
        cell.friendAvatar.image = #imageLiteral(resourceName: "camera_50") //friends[indexPath.row].photo_50
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showUserPhotos",
              let controller = segue.destination as? PhotoCollectionViewController else { return }
        
        let selectedUser = tableView.indexPathForSelectedRow
        controller.userId = selectedUser!.row

    }
    
  

}
