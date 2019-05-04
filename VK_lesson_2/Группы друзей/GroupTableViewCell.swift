//
//  GroupTableViewCell.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Kingfisher

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupLogo: UIImageView!
//        didSet {
//            groupLogo.layer.borderColor = UIColor.white.cgColor
//            groupLogo.layer.borderWidth = 2
//        }
//    }
    
    @IBOutlet weak var groupName: UILabel!
    
    public func configue(with group: Group) {
        
        
        groupLogo.kf.setImage(with: URL(string: group.photo_50))
        groupName.text = group.name
        
    }


}
