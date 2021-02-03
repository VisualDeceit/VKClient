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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendsLastNameTitles = [String]() //массив начальных букв sections
    var friendsDictionary = [String: [User]]()  //словарь
    var filtredFriendsDictionary = [String: [User]]() //для отображения
    
    //реализуем протокол FriendsTableViewControllerDelegate
    func update(indexPhoto: Int, like: Like) {
        //получаем данные из делегата
//        let lastNameKey = friendsLastNameTitles[tableView.indexPathForSelectedRow!.section]
//        if var userValues = friendsDictionary[lastNameKey] {
//            userValues[tableView.indexPathForSelectedRow!.row].album![indexPhoto].like = like
//            friendsDictionary[lastNameKey] = userValues
//            filtredFriendsDictionary[lastNameKey] = userValues
//        }
    }
    
    //
//    private func splitOnSections(for inputArray: [User]) -> ([String], [String: [User]]) {
//
//        var sectionsTitle = [String]()
//        var sectionData = [String: [User]]()
//
//        //разбираем исходный массив в словарь для индексации таблицы
//        for user in inputArray {
//            let lastNameKey = String(user.lastName.prefix(1))
//            if var userValues = sectionData[lastNameKey] {
//                userValues.append(user)
//                sectionData[lastNameKey] = userValues
//            } else {
//                sectionData[lastNameKey] = [user]
//            }
//        }
//
//        //сортируем по алфавиту
//        sectionsTitle = [String](sectionData.keys).sorted(by: <)
//
//        return (sectionsTitle, sectionData)
//
//    }
    
    private func splitOnSections(for inputArray: Results<User>) -> ([String], [String: Results<User>]) {
        
        var sectionsTitle = [String]()
        var sectionData = [String: Results<User>]()
       
        //разбираем исходный массив в словарь для индексации таблицы
        for user in inputArray {
            let lastNameKey = String(user.lastName.prefix(1))
            if var userValues = sectionData[lastNameKey] {
                userValues.append(user)
                sectionData[lastNameKey] = userValues
            } else {
                sectionData[lastNameKey] = [user]
            }
        }
        
        //сортируем по алфавиту
        sectionsTitle = [String](sectionData.keys).sorted(by: <)
        
        return (sectionsTitle, sectionData)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //регистрируем кастомный хедер
        tableView.register(MyCustomSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        // обновление
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        searchBar.delegate = self
        getData()
        
    }
    
    deinit {
        token?.invalidate()
    }
    
    private func getData() {
        //загрузка данных из сети
        let networkService = NetworkServices()
        networkService.getUserFriends()
        
        //загрузка данных из Realm
        do {
            friends = try? RealmService.load(typeOf: User.self).sorted(byKeyPath: #keyPath(User.lastName))
            //подписываемся на уведомления
            token = friends?.observe(tableView.applyChanges)
            // разбор исходных данных
//            (self!.friendsLastNameTitles, self!.friendsDictionary) = self!.splitOnSections(for: self?.friends ?? [User]())
//            //copy dictionary for display
//            self?.filtredFriendsDictionary = self!.friendsDictionary
//            self?.tableView.reloadData()
        }
        catch {
            print(error)
        }
        
        
    }

    @objc
    func refresh(sender:AnyObject) {
        getData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //кол-во секций
       // return filtredFriendsDictionary.count
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //указываем количество строк в секции
//        let lastNameKey = friendsLastNameTitles[section]
//        if let userValues = filtredFriendsDictionary[lastNameKey] {
//            return userValues.count
//        }
//        return 0
        friends?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        //передаем данные в ячейку
//        let lastNameKey = friendsLastNameTitles[indexPath.section]
//        if let userValues = filtredFriendsDictionary[lastNameKey] {
//            cell.populate(user: userValues[indexPath.row])
//        }
        guard let user = friends?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.populate(user: user)
        
        return cell
    }
    
//    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//       //отображение сеций справа
//        return friendsLastNameTitles
//   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showUserPhotos",
              let controller = segue.destination as? PhotoCollectionViewController else { return }
       
        //передача данных в PhotoCollectionViewController
//        let selectedUser = tableView.indexPathForSelectedRow
//        let lastNameKey = friendsLastNameTitles[selectedUser!.section]
//        if let userValues = filtredFriendsDictionary[lastNameKey] {
//            controller.user = userValues[selectedUser!.row]
//        }
        if let user = friends?[tableView.indexPathForSelectedRow?.row ?? 0]  {
            controller.user = user
        }
        
        controller.delegate = self // подписали на делегат

    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
//                                                                "sectionHeader") as! MyCustomSectionHeaderView
//        view.title.text = friendsLastNameTitles[section]
//        return view
//    }
    
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
