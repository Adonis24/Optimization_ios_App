//
//  VKServices.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class VKService {
  
    let baseUrl = "https://api.vk.com"
    
    static let sharedManager: SessionManager = {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        config.timeoutIntervalForRequest = 40
        let manager = Alamofire.SessionManager(configuration: config)
        return manager
    }()
    
   
    
    public func getFriends(completion: (([User]?, Error?) -> Void)? = nil)  {
        let extFields = "first_name,last_name,photo_50,photo_100,photo_200,photo_400_orig,deactivated"
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token":Session.instance.token,
            "fields": extFields,
            "order":"name",
            "v":"5.85"
        ]
        
        
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let users = json["response"]["items"].arrayValue.map { User(json: $0) }
                completion?(users, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    public func getFoto(owner_id: Int, completion:  (([Photo]?, Error?) -> Void)? = nil)  {
        
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "access_token":Session.instance.token,
            "owner_id": owner_id,
            "photo_sizes": 1,
            "count":100,
            "v":"5.85"
        ]
        
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let photos = json["response"]["items"].arrayValue.map { Photo(json: $0) }
                completion?(photos, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    

    public func getGroup( completion: (([Group]?, Error?) -> Void)? = nil)  {
        
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token":Session.instance.token,
            "extended":"1",
            "v":"5.85"
        ]
        
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                completion?(groups, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    func deleteGroups(for group_id: Int, completion: (([Group]?, Error?) -> Void)? = nil) {
        let path = "/method/groups.leave"
        let params: Parameters = [
            "access_token" : Session.instance.token,
            "group_id" : group_id,
            "v": "5.85"
        ]
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                completion?(groups, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }
    }
    public func  searchGroup(searchText: String, completion: (([Group]?, Error?) -> Void)? = nil)  {
        
        let path = "/method/groups.search"
        let params: Parameters = [
            "access_token":Session.instance.token,
            "q":String(searchText),
            "v":"5.85"
        ]
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
                completion?(groups, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }

    }
    
    public func getNews(completion: (([News]?, Error?) -> Void)? = nil)
    {
//        var profiles=[User]()
//        var groups=[Group]()
        let path = "/method/newsfeed.get"
        let params: Parameters = [
            "access_token":Session.instance.token,
            "filters":"post",
            "count":"10",
            "v": "5.85"
        ]
        let queue = DispatchQueue(label: "com.newsfeed.get.vk.api", qos: .utility, attributes: [.concurrent])
        VKService.sharedManager.request(baseUrl+path, method: .get, parameters: params)
            
            .responseJSON (queue: queue, options: .allowFragments,
                           completionHandler: {response in
            
            switch response.result {
        
            case .success(let value):
                let json = JSON(value)
                let news = json["response"]["items"].arrayValue.map { News(json: $0) }
               // let profiles = json["response"]["profiles"].arrayValue.map{ Profiles(json: $0) }
                //let groups = json["response"]["groups"].arrayValue.map{Group(json: $0)}
                completion?(news,nil)
            case .failure(let error):
                completion?(nil,error)
            }
        })
    }
    
    
}
