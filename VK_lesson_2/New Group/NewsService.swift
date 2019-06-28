//
//  NewsService.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 19/06/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsService {
    static var realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    public var news = [News]()
    var profiles=[User]()
    var groups=[Group]()
    let baseUrl = "https://api.vk.com"
    
    static let sharedManager: SessionManager = {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
    public func updateNews() {
        
        getNewsJson { (news, error) in
            
            guard news  != nil else {
                print(error?.localizedDescription as Any)
                return}
            
        }
        }
    
    //получим json  по новостям
    public func getNewsJson(completion: (([News]?, Error?) -> Void)? = nil)
    {
        
        let path = "/method/newsfeed.get"
        let params: Parameters = [
            "access_token":Session.instance.token,
            "filters":"post",
            "count":"10",
            "v": "5.85"
        ]
      //  let queue = DispatchQueue(label: "com.newsfeed.get.vk.api", qos: .utility, attributes: [.concurrent])
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params)
            
      //     .responseJSON (queue: queue, options: .allowFragments,
       //                   completionHandler: {response in
            .responseJSON (completionHandler: {response in
                            switch response.result {
                                
                            case .success(let value):
                                let json = JSON(value)
                                
                                self.processingNewsData(json: json)
                                
                                completion?(self.news ,nil)
                            case .failure(let error):
                                completion?(nil,error)
                            }
            })
    }
    
    public func processingNewsData(json:JSON){
       let queue = DispatchQueue(label: "save Realm", qos: .utility)
       let grProcessing =  DispatchGroup() //   Создаем группу для включения в нее параллельных очередей по парсингу каждого типа
        //*****Парсинг новостей
        DispatchQueue.global(qos: .userInteractive).async(group:grProcessing) {
            self.news = json["response"]["items"].arrayValue.map{News(json: $0)}
        }
        //\\*****Парсинг новостей
        
        //*****Парсинг профилей
        DispatchQueue.global(qos: .userInteractive).async(group: grProcessing) {
            self.profiles = json["response"]["profiles"].arrayValue.map{User(json:$0)}
        }
        //\\*****Парсинг профилей
        
        //***** Парсинг групп
        DispatchQueue.global(qos: .userInteractive).async(group: grProcessing) {
           self.groups   = json["response"]["groups"].arrayValue.map{Group(json: $0)}
        }
        //\\***** Парсинг групп
        // Без использования параллельной обработки
        //self.news = json["response"]["items"].arrayValue.map{News(json: $0)}
        //self.profiles = json["response"]["profiles"].arrayValue.map{User(json:$0)}
        //self.groups   = json["response"]["groups"].arrayValue.map{Group(json: $0)}
        //self.saveNewsToRealm(news: self.news)
        //      }
        //\\ Без использования параллельной обработки
  
        grProcessing.notify(queue: queue)
        { self.saveNewsToRealm(news:self.news) }
    }
    func saveNewsToRealm(news:[News]){
        for event in news {
            let id_source = abs(event.source_id)
            if isProfileSource(id:event.source_id)
            {
                for person in profiles
                {
                    if person.id == id_source
                    {
                        // инициализируем дополнительные поля для отображения заговлока новости
                        event.name_lable = person.first_name + " " + person.last_name
                        event.icon_image = person.photo_50
                        
                    }
                }
            }
            else
            {
                for group in groups
                {
                    if group.id == id_source
                    {
                        event.name_lable = group.name
                        event.icon_image = group.photo_50
                    }
                }
                
            }
        }
     
            
        RealmProvider.save(items: news)
    }
    
    func isProfileSource(id:Int)->Bool
    {
        return id == abs(id)
        
    }
}
