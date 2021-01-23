//
//  AllGroupsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 12.12.2020.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    //var allGroups = [Group(name: "Пикабу", screen_name: "pikabu", logo: #imageLiteral(resourceName: "rZi7F9_vu-8") ),
    //                 Group(name: "ТОПОР — Хранилище", screen_name: "toportg", logo: #imageLiteral(resourceName: "-LGOrMnatj4")),
    //                 Group(name: "Подслушано Коломна", screen_name: "kolomna_tut", logo: #imageLiteral(resourceName: "i9FnKM0Gxt4")),]
    
    var allGroups = [Group]()
    var filtredAllGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        filtredAllGroups = allGroups
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filtredAllGroups.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupCell", for: indexPath) as? AllGroupsTableViewCell
        else { return UITableViewCell()}
        
        cell.groupName.text = filtredAllGroups[indexPath.row].name
        //cell.groupImage.image = filtredAllGroups[indexPath.row].logo!
       // cell.groupImage.logoView.image =  filtredAllGroups[indexPath.row].logo ?? UIImage()
        
        return cell
    }

}

extension AllGroupsTableViewController: UISearchBarDelegate {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            filtredAllGroups = allGroups
            tableView.reloadData()
            return
        }
        filtredAllGroups = allGroups.filter{ $0.name.lowercased().contains(searchText.lowercased())}
        
        tableView.reloadData()
    }
    
}
