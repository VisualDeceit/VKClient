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
    
    private var friendsBySection = [Results<User>]()
    private var friendsBySectionBackup = [Results<User>]()
    var notificationTokens = [NotificationToken]()
    var friendsLastNameTitles = [String]()
    var friendsLastNameTitlesBackup = [String]()
    var isSearching: Bool = false
    
    private var allFriends = try? RealmService.load(typeOf: User.self)

    var allFriendsToken: NotificationToken?
    
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
        
        //на первый запуск
        if (allFriends?.count == 0) {
            allFriendsToken = allFriends?.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial: break
                case .update(let result, _, _, _):
                    //устанавливаем уведомления
                    self?.setNotificatoins(for: result)
                    //отписываемcя
                    self?.allFriendsToken?.invalidate()
                    tableView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } else {
            setNotificatoins(for: allFriends!)
        }
        
        // обновление
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        searchBar.delegate = self
    }
    
    // MARK: - Notifications
    
    func setNotificatoins(for container: Results<User>) {
        //рабиваем на секции
        friendsLastNameTitles = splitOnSections(for: container)
        // подписываем
        initFriendsBySection(sections: friendsLastNameTitles)
        // for serch
        friendsBySectionBackup = friendsBySection
        friendsLastNameTitlesBackup = friendsLastNameTitles
    }
    
    func initFriendsBySection (sections: [String]) {
        //получаем коллекцию для каждой секции по первой букве фамилии
        for section in sections {
            let friends =  try? RealmService.load(typeOf: User.self).filter("lastName BEGINSWITH %@", section)
            if let friends = friends {
                friendsBySection.append(friends)
            }
        }
        //устанавливаем для коллекции уведомления
        for (index, friends) in friendsBySection.enumerated() {
            addNotification(for: friends, in: index)
        }
    }
    
    
    func addNotification(for container: Results<User>, in section:Int) {
        let token = (container.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                guard self?.isSearching == false else { return }
                tableView.beginUpdates()
                //tableView.reloadSections(IndexSet.init(integer: section), with: .automatic)
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
        //запоминаем токен в масссив
        notificationTokens.append(token)
    }
    
    //находим массив первых букв
    func splitOnSections(for inputArray: Results<User>) -> [String] {
        
        var dictionary = [String: [User]]()
       
        //разбираем исходный массив в словарь для индексации таблицы
        for user in Array(inputArray) {
            let lastNameKey = String(user.lastName.prefix(1))
            if var userValues = dictionary[lastNameKey] {
                userValues.append(user)
                //добавляем
                dictionary[lastNameKey] = userValues
            } else {
                //новое
                dictionary[lastNameKey] = [user]
            }
        }
        return [String](dictionary.keys).sorted(by: <)
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
        return friendsBySection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //указываем количество строк в секции
        return friendsBySection[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        //передаем данные в ячейку
        cell.populate(user: friendsBySection[indexPath.section][indexPath.row])
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
        controller.user = friendsBySection[selectedUser!.section][selectedUser!.row]
        controller.delegate = self // подписали на делегат

    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! MyCustomSectionHeaderView
        view.title.text = friendsLastNameTitles[section]
        return view
    }
    
}

//MARK: - Searching

extension FriendsTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else {
            friendsBySection = friendsBySectionBackup
            friendsLastNameTitles = friendsLastNameTitlesBackup
            isSearching = false
            tableView.reloadData()
           return
        }

        do {
            isSearching = true
            let predicate = NSPredicate(format: "firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@"  , searchText.lowercased(), searchText.lowercased())
            let filteredFriends =  try RealmService.load(typeOf: User.self).filter(predicate)
            ///рабиваем на секции
            friendsLastNameTitles.removeAll()
            friendsLastNameTitles = splitOnSections(for: filteredFriends)
            ////получаем коллекцию для каждой секции по первой букве фамилии
            friendsBySection.removeAll()
            for section in friendsLastNameTitles {
                let friends = filteredFriends.filter("lastName BEGINSWITH %@", section)
                friendsBySection.append(friends)
            }
            tableView.reloadData()
        }
        catch {
            print(error)
        }
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
