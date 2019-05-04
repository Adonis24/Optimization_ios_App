//
//  Photo.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/02/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class Photo: Object   {
    
    
    
    @objc dynamic var id: Int = 0
    @objc dynamic var photoOwnerId: Int = 0
    @objc dynamic var  src: String = ""
    @objc dynamic var  type: String = ""
    @objc dynamic var  url: String = ""
    @objc dynamic var descrip: String = ""
    let photosForUser = LinkingObjects(fromType: User.self, property: "photos")
    
    //init(json: JSON) {
    convenience  init(json:JSON) {
        self.init()
        self.id = json["id"].intValue
        self.src = json["sizes"]["src"].stringValue
        self.type = json["sizes"]["type"].stringValue
        self.url = json["sizes"][8]["url"].stringValue
        self.photoOwnerId = json["owner_id"].intValue
        self.descrip = "\(id) "
    }
    
    override static func primaryKey()->String {
        return "id"
    }
    
}
