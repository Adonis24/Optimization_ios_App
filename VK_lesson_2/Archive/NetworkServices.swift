//
//  AlamofireServices.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 09/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
//Получение списка друзей;
//Получение фотографий человека;
//Получение групп текущего пользователя;
//Получение групп по поисковому запросу;

enum typeRequest {
    
    case getFriends
    case getFotos
    case getGroups
    case getSearchGroups
    case getNews
    
}

class NetworkServices{
    

    public func sendRequest(type: typeRequest){
        let url = "https://api.vk.com"
        
        switch type {
        case .getFriends:
            
        let path = "/method/friends.get"
        let parameters: Parameters = [
            "access_token":Session.instance.token,
            "order":"name",
            "fields":"city",
            "v":"5.85"
            ]
        
        Alamofire.request(url+path, method: .get, parameters:parameters)
            .responseJSON{response in
        guard let value = response.value else {return}
        print(value)
            }
            
        case .getFotos:
            let path = "/method/photos.get"
            let parameters: Parameters = [
                "access_token":Session.instance.token,
                "owner_id":"-1",
                "album_id":"wall",
                "count":"1",
                "v":"5.85"
            ]
            
            Alamofire.request(url+path, method: .get, parameters:parameters)
                .responseJSON{response in
                    guard let value = response.value else {return}
                    print(value)
            }
        case .getGroups: //groups.get
            let path = "/method/groups.get"
            let parameters: Parameters = [
                "access_token":Session.instance.token,
                "extended":"1",
                "count":"1",
                "v":"5.85"
            ]
            
            Alamofire.request(url+path, method: .get, parameters:parameters)
                .responseJSON{response in
                    guard let value = response.value else {return}
                    print(value)}
        case .getSearchGroups://groups.search
                    let path = "/method/groups.search"
                    let parameters: Parameters = [
                        "q":"",
                        "v":"5.85"
                    ]
                    
                    Alamofire.request(url+path, method: .get, parameters:parameters)
                        .responseJSON{response in
                            guard let value = response.value else {return}
                            print(value)}
            
            
        case .getNews:
            let path = "/method/newsfeed.get"
            let parameters: Parameters = [
                "access_token":Session.instance.token,
                "filters":"post",
                "count":"10",
                "v":"5.95"
            ]
            
            Alamofire.request(url+path, method: .get, parameters:parameters)
                .responseJSON{response in
                    guard let value = response.value else {return}
                    print(value)}
            
        }
        
    }
   
    
}
