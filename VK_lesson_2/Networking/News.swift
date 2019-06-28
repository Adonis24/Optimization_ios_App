//
//  News.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 06/05/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News:Object {
    
    
    @objc dynamic  var post_id: Int = 0
    @objc dynamic  var type: String = "" // тип списка новости, соответствующий одному из значений параметра filters;
    @objc dynamic var  source_id: Int = 0 // идентификатор источника новости (положительный — новость пользователя, отрицательный — новость группы);
    @objc dynamic var date: Double = 0.0 // время публикации новости в формате unixtime;
    @objc dynamic var text: String = "" //находится в записях со стен и содержит текст записи;
    @objc dynamic var comments_count: Int = 0 // Количество комментариев
    @objc dynamic var likes_count: Int = 0 // Количество комментариев
    @objc dynamic var reposts_count: Int = 0 // Количество    репостов
    @objc dynamic var views_count: Int = 0 // Количество   просмотров
    @objc dynamic var name_lable: String = "" // краткое имя автора - группы или пользователя
    @objc dynamic var icon_image: String = "" // фото автора - группы или пользователя
    @objc dynamic var descrip: String = ""
//    @objc dynamic var source_group:Group?
//    @objc dynamic var source_user: User?
//   var groupsForNews = LinkingObjects(fromType: Group.self, property: "groups")
   //var usersForNews  = LinkingObjects(fromType: User.self, property: "users")
    var photo: List = List<Photo>()

    convenience  init(json:JSON) {
        self.init()
        
        self.post_id = json["post_id"].intValue
        self.type = json["type"].stringValue
        self.source_id = json["source_id"].intValue
        self.date = json["date"].doubleValue
        self.text = json["text"].stringValue
        self.comments_count = json["comments"]["count"].intValue
        self.likes_count = json["likes"]["count"].intValue
        self.reposts_count = json["reposts"]["count"].intValue
        self.views_count = json["views"]["count"].intValue
        
        for attach in json["attachments"].arrayValue {
            self.photo.append(Photo(json: attach ["photo"]))
        }
        for history in json["copy_history"].arrayValue {
            for attach in history["attachments"].arrayValue {
                self.photo.append(Photo(json: attach ["photo"]))
            }
        }
        self.descrip = "\(post_id) "
    }

    override static func primaryKey()->String {
        return "post_id"
    }
    
    
}
//class Profiles: Object{
//    @objc dynamic var id: Int = 0
//    @objc dynamic var first_name: String = ""
//    @objc dynamic var last_name: String = ""
//    @objc dynamic var photo_50: String = ""
//    @objc dynamic var cashed_icon: String = ""
//    
//    convenience init(json: JSON) {
//        self.init()
//        
//        self.id = json["id"].intValue
//        self.first_name = json["first_name"].stringValue
//        self.last_name = json["last_name"].stringValue
//        self.photo_50 = json["photo_50"].stringValue
//    }
//}
//class Groups: Object{
//    @objc dynamic var id: Int = 0
//    @objc dynamic var name: String = ""
//    @objc dynamic var photo_50: String = ""
//    @objc dynamic var cashed_icon: String = ""
//    
//    convenience init(json: JSON) {
//        self.init()
//        
//        self.id = json["id"].intValue
//        self.name = json["name"].stringValue
//        self.photo_50 = json["photo_50"].stringValue
//        
//    }
//}
