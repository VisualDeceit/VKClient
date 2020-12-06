//
//  LoginFormController.swift
//  VkClient
//
//  Created by Alexander Fomin on 02.12.2020.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet var loginInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    
    //проверка авторизации
    private func userCheck() -> Bool {
        guard let login = loginInput.text,
              let password = passwordInput.text else {
            return false
        }
        
        return login == "test@mail.ru" && password == "0000"
    }
    
    // предупреждение
    private func showAlert(){
        let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: {_ in
            self.loginInput.text = ""
            self.passwordInput.text = ""
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard userCheck() else {
            showAlert()
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Прячем TabBar на login screen 
        tabBarController?.tabBar.isHidden = true
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

    
    @objc func hideKeyboard() {
            self.scrollView?.endEditing(true)
        }

    @objc func keyboardWasShown(notification: Notification) {
            
            // Получаем размер клавиатуры
            let info = notification.userInfo! as NSDictionary
            let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            
            // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
            self.scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
        }
        
        //Когда клавиатура исчезает
        @objc func keyboardWillBeHidden(notification: Notification) {
            // Устанавливаем отступ внизу UIScrollView, равный 0
            let contentInsets = UIEdgeInsets.zero
            scrollView?.contentInset = contentInsets
        }

}
