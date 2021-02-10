//
//  VKLoginViewController.swift
//  VkClient
//
//  Created by Alexander Fomin on 17.01.2021.
//

import UIKit
import WebKit
import Firebase


class VKLoginViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7728935"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.126")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        //очищаем cookie
        let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
                for record in records {
                    if record.displayName.contains("vk") {
                        dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {
                            print("Deleted: " + record.displayName);
                        })
                    }
                }
            }
        
        webView.load(request)
    }
}

extension VKLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }

        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }

        Session.shared.token = params["access_token"]
        Session.shared.userId = params["user_id"]
        
        //сохраняем данные о юзаре в Firebase
        addToFirebase(id: Session.shared.userId)
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "ToMainTabBar", sender: nil)
    }
    
    func addToFirebase(id: String?) {
        let firebaseUser = FirebaseUsers(id: id ?? "-1", date: Int(Date().timeIntervalSince1970))
        
        let ref = Database.database(url: "https://vkclient-a78cb-default-rtdb.europe-west1.firebasedatabase.app/").reference(withPath: "users")
        
        let userRef = ref.child(id ?? "-1")
        userRef.setValue(firebaseUser.toAnyObject())
    }
}

