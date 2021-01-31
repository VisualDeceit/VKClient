//
//  GroupsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

class GroupsTableViewController: UITableViewController {

    var groups = [Group]()
    var filtredUserGroups = [Group]()
        
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        searchBar.delegate = self
        getData()
    }
    
    private func getData() {
        let networService = NetworkServices()
        networService.getUserGroups { [weak self] in
            //загрузка данных из Realm
            self?.groups = Array(try! RealmService.load(typeOf: Group.self))
            self?.filtredUserGroups = self?.groups ?? [Group]()
            self?.tableView.reloadData()
        }
    }
    
    @objc
    func refresh(sender:AnyObject) {
        getData()
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredUserGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as? GroupTableViewCell
        else { return UITableViewCell() }
        
        cell.populate(group: filtredUserGroups[indexPath.row])
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let removed = filtredUserGroups.remove(at: indexPath.row)
            if let index = groups.firstIndex(of: removed) {
                groups.remove(at: index)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //снимаем выделение
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Добавление группы
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "AddGroup" {
            guard let allGroupsController = segue.source as? AllGroupsTableViewController else
            { return }
            
//            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
//                let group = allGroupsController.filtredAllGroups[indexPath.row]
//                if !userGroups.contains(group) {
//                    filtredUserGroups.append(group)
//                    userGroups.append(group)
//                    tableView.reloadData()
//                }
//            }
        }
        
    }
}

extension GroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            filtredUserGroups = groups
            tableView.reloadData()
            return
        }
        filtredUserGroups = groups.filter{ $0.name.lowercased().contains(searchText.lowercased())}
        
        tableView.reloadData()
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}
