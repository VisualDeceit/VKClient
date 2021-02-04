//
//  FriendsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit
import RealmSwift

//протокол для делегата
protocol FriendsTableViewControllerDelegate: class {
    func update(indexPhoto: Int, like: Like)
}

class FriendsTableViewController: UITableViewController, FriendsTableViewControllerDelegate {
  
    private var friends: Results<User>?
    var notificationTokens = [NotificationToken]()
        
    var friendsLastNameTitles = [String]() //массив начальных букв sections
    var friendsDictionary = [String: [User]]()  //словарь; Int - индекс в Realm
    var filtredFriendsDictionary = [String: [User]]() //для отображения
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //реализуем протокол FriendsTableViewControllerDelegate
    func update(indexPhoto: Int, like: Like) {
        //получаем данные из делегата
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //регистрируем кастомный хедер
        tableView.register(MyCustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        //загрузка данных из сети
        let networkService = NetworkServices()
        networkService.getUserFriends()
        
        //устанавливаем уведомления
        let object = try! RealmService.load(typeOf: User.self)
        splitOnSections(for: object)
        initObjectsBySection(sections: friendsLastNameTitles)
        
        // обновление
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        searchBar.delegate = self
    }
    
    // MARK: - Notifications
    
    func initObjectsBySection (sections: [String]) {
        var objectsBySection = [Results<User>]()
        
        for section in sections {
            let objects =  try? RealmService.load(typeOf: User.self).filter("lastName BEGINSWITH %@", section)
            if let objects = objects {
                objectsBySection.append(objects)
            }
        }
        
        for (index, objects) in objectsBySection.enumerated() {
            addNotificationBlock(for: objects, in: index)
        }
        
    }
    
    
    func addNotificationBlock(for results: Results<User>?, in section:Int) {
        let token = (results?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: section) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: section)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: section) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        })
        
        notificationTokens.append(token!)
    }
    
    private func splitOnSections(for inputArray: Results<User>) {
        
        friendsLastNameTitles.removeAll()
        friendsDictionary.removeAll()
       
        //разбираем исходный массив в словарь для индексации таблицы
        for user in Array(inputArray) {
            let lastNameKey = String(user.lastName.prefix(1))
            if var userValues = friendsDictionary[lastNameKey] {
                userValues.append(user)
                //добавляем
                friendsDictionary[lastNameKey] = userValues
            } else {
                //новое
                friendsDictionary[lastNameKey] = [user]
            }
        }
        
        filtredFriendsDictionary = friendsDictionary
        //сортируем по алфавиту
        friendsLastNameTitles = [String](friendsDictionary.keys).sorted(by: <)

    }

    
    deinit {
        notificationTokens.forEach{$0.invalidate()}
    }
    
    @objc func refresh(sender:AnyObject) {
        //загрузка данных из сети
        let networkService = NetworkServices()
        networkService.getUserFriends()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //кол-во секций
        return filtredFriendsDictionary.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //указываем количество строк в секции
        let lastNameKey = friendsLastNameTitles[section]
        if let userValues = filtredFriendsDictionary[lastNameKey] {
            return userValues.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        //передаем данные в ячейку
        let lastNameKey = friendsLastNameTitles[indexPath.section]
        if let userValues = filtredFriendsDictionary[lastNameKey] {
            cell.populate(user: userValues[indexPath.row])
        }
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
       //отображение сеций справа
        return friendsLastNameTitles
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showUserPhotos",
              let controller = segue.destination as? PhotoCollectionViewController else { return }
       
        //передача данных в PhotoCollectionViewController
        let selectedUser = tableView.indexPathForSelectedRow
        let lastNameKey = friendsLastNameTitles[selectedUser!.section]
        if let userValues = filtredFriendsDictionary[lastNameKey] {
            controller.user = userValues[selectedUser!.row]
        }
        
        controller.delegate = self // подписали на делегат

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! MyCustomSectionHeaderView
        view.title.text = friendsLastNameTitles[section]
        return view
    }
    
}

//searching
extension FriendsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            filtredFriendsDictionary = friendsDictionary
            friendsLastNameTitles = [String](filtredFriendsDictionary.keys).sorted(by: <)
            tableView.reloadData()
            return
        }
        
        filtredFriendsDictionary = friendsDictionary.mapValues{
            $0.filter {
                $0.firstName.lowercased().contains(searchText.lowercased()) ||
                    $0.lastName.lowercased().contains(searchText.lowercased())
            }
        }.filter {!$0.value.isEmpty}
        
        friendsLastNameTitles = [String](filtredFriendsDictionary.keys).sorted(by: <)
        tableView.reloadData()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
