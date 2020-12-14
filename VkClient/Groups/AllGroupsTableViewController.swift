//
//  AllGroupsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 12.12.2020.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {

    var allGroups = [Group(name: "Пикабу", screen_name: "pikabu", logo: #imageLiteral(resourceName: "rZi7F9_vu-8") ),
                     Group(name: "ТОПОР — Хранилище", screen_name: "toportg", logo: #imageLiteral(resourceName: "-LGOrMnatj4")),
                     Group(name: "Подслушано Коломна", screen_name: "kolomna_tut", logo: #imageLiteral(resourceName: "i9FnKM0Gxt4")),
                                      ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGroups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as? AllGroupsTableViewCell
        else { return UITableViewCell()}
        
        cell.groupName.text = allGroups[indexPath.row].name
        cell.groupImage.image = allGroups[indexPath.row].logo!
        
        return cell
    }



}
