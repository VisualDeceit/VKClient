//
//  FriendsTableViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 11.12.2020.
//

import UIKit

//протокол для делегата
protocol FriendsTableViewControllerDelegate: class {
    func update(indexPhoto: Int, like: Like)
}

class FriendsTableViewController: UITableViewController, FriendsTableViewControllerDelegate {
    
    var friends = [
        User(first_name: "Александр", last_name: "Фомин"),
        User(first_name: "Юрий", last_name: "Султанов"),
        User(first_name: "Никита", last_name: "Сергеев"),
        User(first_name: "Артем", last_name: "Зарудный"),
        User(first_name: "Виталий", last_name: "Степушин"),
        User(first_name: "Юрий", last_name: "Фёдоров"),
        User(first_name: "Татьяна", last_name: "Сундукова"),
        User(first_name: "Даниил", last_name: "Книсс"),
        User(first_name: "Хасан", last_name: "Сатийаджиев"),
        User(first_name: "Никита", last_name: "Максимов"),
        User(first_name: "Игорь", last_name: "Гомзяков"),
        User(first_name: "Василий", last_name: "Князев"),
        User(first_name: "Артём", last_name: "Сарана"),
        User(first_name: "Денис", last_name: "Юрчик"),
        User(first_name: "Роман", last_name: "Вертячих"),
        User(first_name: "Айрат", last_name: "Бариев"),
        User(first_name: "Никита", last_name: "Грас"),
        User(first_name: "Дмитрий", last_name: "Коврига"),
        User(first_name: "Никита", last_name: "Кулигин"),
        User(first_name: "Никита", last_name: "Рухайло"),
        User(first_name: "Никита", last_name: "Кочнев"),
        User(first_name: "Кирилл", last_name: "Васильев"),
        User(first_name: "Сергей", last_name: "Лысов"),
        User(first_name: "Руслана", last_name: "Иванова"),
        User(first_name: "Наталья", last_name: "Филимонова"),
        User(first_name: "Максим", last_name: "Тулинов"),
        User(first_name: "Юрий", last_name: "Егоров"),
        User(first_name: "Евгений", last_name: "Дербенев"),
        User(first_name: "Дмитрий", last_name: "Борисов"),
        User(first_name: "Игорь", last_name: "Могонов"),
        User(first_name: "Николай", last_name: "Устинов"),
        User(first_name: "Сергей", last_name: "Нелюбин"),
        User(first_name: "Виктор", last_name: "Гарицкий"),
        User(first_name: "Николай", last_name: "Устинов"),
        User(first_name: "Лев", last_name: "Бажков"),
        User(first_name: "Алексей", last_name: "Нестеров"),
        User(first_name: "Роман", last_name: "Устинов"),
        User(first_name: "Николай", last_name: "Перепел"),
    ]
    
    //массив начальных букв фамилий
    var friendsLastNameTitles = [String]()
    //словарь
    var friendsDictionary = [String: [User]]()
    
    //реализуем протокол FriendsTableViewControllerDelegate
    func update(indexPhoto: Int, like: Like) {
        //получаем данные из делегата
        let lastNameKey = friendsLastNameTitles[tableView.indexPathForSelectedRow!.section]
        if var userValues = friendsDictionary[lastNameKey] {
            userValues[tableView.indexPathForSelectedRow!.row].album![indexPhoto].like = like
            friendsDictionary[lastNameKey] = userValues
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //разбираем исходный массив в словарь для индексации таблицы
        for user in friends {
            let lastNameKey = String(user.last_name.prefix(1))
            if var userValues = friendsDictionary[lastNameKey] {
                userValues.append(user)
                friendsDictionary[lastNameKey] = userValues
            } else {
                friendsDictionary[lastNameKey] = [user]
            }
        }
        
        //сортируем по алфавиту
        friendsLastNameTitles = [String](friendsDictionary.keys).sorted(by: <)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //кол-во секций
        return friendsLastNameTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //указываем количество строк в секции
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
        //передаем данные в ячейку
        let lastNameKey = friendsLastNameTitles[indexPath.section]
        if let userValues = friendsDictionary[lastNameKey] {
            cell.friendName.text = "\(userValues[indexPath.row].first_name) \(userValues[indexPath.row].last_name)"
            cell.friendAvatar.logoView.image = #imageLiteral(resourceName: "camera_50")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //заголовки секций
        return friendsLastNameTitles[section]
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
        if let userValues = friendsDictionary[lastNameKey] {
            controller.user = userValues[selectedUser!.row]
        }
        controller.delegate = self // подписали на делегат

    }
    
}
