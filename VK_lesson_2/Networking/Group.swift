//
//  Group.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class Group: Object  {

    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo_50: String = ""
    @objc dynamic var descrip: String = ""
    var news   = List<News>()
    
     // let groupForNews = LinkingObjects(fromType: News.self, property: "groups")
   // init(json:JSON) {
    convenience  init(json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photo_50 = json["photo_50"].stringValue
        self.descrip = "Group: \(self.id) \(self.name)"
        
    
        
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    var toAnyObject: Any {
        return [
            "name": name,
            "photo_50": photo_50,
            "id": id
            
        ]
    }
}
