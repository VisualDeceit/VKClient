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
    var token: NotificationToken?
        
    var friendsLastNameTitles = [String]() //массив начальных букв sections
    var friendsDictionary = [String: [User]]()  //словарь
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
        
        //устанавливаем наблюдатель
        pairTableAndRealm()
        
        // обновление
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        searchBar.delegate = self
    }
    
    
    func pairTableAndRealm() {
        friends = try? RealmService.load(typeOf: User.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial(let result):
                //разбиваем на секции
                self?.splitOnSections(for: result)
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    private func splitOnSections(for inputArray: Results<User>?) {
        
        guard let array = inputArray else { return }
        
        friendsLastNameTitles.removeAll()
        friendsDictionary.removeAll()
       
        //разбираем исходный массив в словарь для индексации таблицы
        for user in Array(array) {
            let lastNameKey = String(user.lastName.prefix(1))
            if var userValues = friendsDictionary[lastNameKey] {
                userValues.append(user)
                friendsDictionary[lastNameKey] = userValues
            } else {
                friendsDictionary[lastNameKey] = [user]
            }
        }
        
        filtredFriendsDictionary = friendsDictionary
        //сортируем по алфавиту
        friendsLastNameTitles = [String](friendsDictionary.keys).sorted(by: <)

    }

    
    deinit {
        token?.invalidate()
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
//        guard let user = friends?[indexPath.row] else {
//            return UITableViewCell()
//        }
//
//        cell.populate(user: user)
        
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
//        if let user = friends?[tableView.indexPathForSelectedRow?.row ?? 0]  {
//            controller.user = user
//        }
        
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
