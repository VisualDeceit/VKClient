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
  
    private var friends = [User]()
//    private lazy var friends = try? RealmService.load(typeOf: User.self){
//        didSet {
//            // разбор исходных данных
//            (friendsLastNameTitles, friendsDictionary) = splitOnSections(for: friends!)
//            //copy dictionary for display
//            filtredFriendsDictionary = friendsDictionary
//            tableView.reloadData()
//        }
//    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendsLastNameTitles = [String]() //массив начальных букв sections
    var friendsDictionary = [String: [User]]()  //словарь
    var filtredFriendsDictionary = [String: [User]]() //для отображения
    
    //реализуем протокол FriendsTableViewControllerDelegate
    func update(indexPhoto: Int, like: Like) {
        //получаем данные из делегата
        let lastNameKey = friendsLastNameTitles[tableView.indexPathForSelectedRow!.section]
//        if var userValues = friendsDictionary[lastNameKey] {
//            userValues[tableView.indexPathForSelectedRow!.row].album![indexPhoto].like = like
//            friendsDictionary[lastNameKey] = userValues
//            filtredFriendsDictionary[lastNameKey] = userValues
//        }
    }
    
    //
    private func splitOnSections(for inputArray: [User]) -> ([String], [String: [User]]) {
        
        var sectionsTitle = [String]()
        var sectionData = [String: [User]]()
       
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
        
        searchBar.delegate = self
        
        let networkService = NetworkServices()
        networkService.getUserFriends {[weak self] friends in
            // если не сделать, то выдапает ошибка
            /// UITableView.reloadData() must be used from main thread only
            DispatchQueue.main.async {
                //сохранение данных в Realm
                try? RealmService.save(items: friends)
                //загрузка данных из Realm
                self?.friends = Array(try! RealmService.load(typeOf: User.self))
                // разбор исходных данных
                (self!.friendsLastNameTitles, self!.friendsDictionary) = self!.splitOnSections(for: friends)
                //copy dictionary for display
                self?.filtredFriendsDictionary = self!.friendsDictionary
                self?.tableView.reloadData()
            }
        }
        
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
            controller.userID = userValues[selectedUser!.row].id
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
