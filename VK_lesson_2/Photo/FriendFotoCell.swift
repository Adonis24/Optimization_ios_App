//
//  FiendFotoCell.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Kingfisher

class FriendFotoCell: UICollectionViewCell {
    
    @IBOutlet weak var friendFotos: UIImageView!
    

    
    public func configue(with url_photo: String) {
        
       
        if url_photo != "" {
            friendFotos.kf.setImage(with: URL(string: url_photo))
        }
      
        
    }
}
