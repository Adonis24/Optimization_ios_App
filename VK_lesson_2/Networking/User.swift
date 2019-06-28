//
//  User.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
//    var description: String {
//        return "\(first_name) \(last_name)"
//    }
    
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_50: String = ""
    @objc dynamic var photo_100: String = ""
    @objc dynamic var photo_200: String = ""
    @objc dynamic var photo_400_orig: String = ""
    @objc dynamic var deactivated: String = ""
    @objc dynamic var descrip: String = ""
    var photos = List<Photo>()
    var news   = List<News>()
    //let userForNews = LinkingObjects(fromType: News.self, property: "users")
    //init(json: JSON) {
     convenience  init(json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.photo_200 = json["photo_200"].stringValue
        self.photo_400_orig = json["photo_400_orig"].stringValue
        self.deactivated = json["deactivated"].stringValue
        self.descrip = "\(self.first_name) \(self.last_name)"
        
    }
    
    override static func primaryKey() -> String{
        return "id"
    }
    // for firebase
    var toAnyObject: Any {
        return [
            "first_name": first_name,
            "photo_50": photo_50
        ]
    }
}


