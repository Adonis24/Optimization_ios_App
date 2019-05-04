//
//  VKOauthController.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 09/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Foundation
import WebKit
import Alamofire

class VKOauthController: UIViewController {
 
    @IBOutlet weak var webView: WKWebView!{
    didSet {
    webView.navigationDelegate = self
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
//let session = Session.instance
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6704883"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.85")
        ]
        //6704883
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension VKOauthController:WKNavigationDelegate{
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
       // print(params)
        guard let token = params["access_token"], let userId = Int(params["user_id"]!) else {
            decisionHandler(.cancel)
            return
        }
        
      //  print(token, userId)
        let session = Session.instance
        session.token = token
        session.userId = userId
       
       performSegue(withIdentifier: "VKLogin", sender: nil)
        decisionHandler(.cancel)
    }

}
