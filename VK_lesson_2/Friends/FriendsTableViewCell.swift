//
//  FriendsTableViewCell.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit

  class FriendsTableViewCell: UITableViewCell {

   
  
    @IBOutlet weak var friendLogo: UIImageView!
    
    @IBOutlet weak var friendName: UILabel!
    
 
    @IBOutlet weak var shadowView: UIView!

    

    override func layoutSubviews() {
        super.layoutSubviews()

        friendLogo.layer.cornerRadius = friendLogo.frame.height/2
        friendLogo.layer.masksToBounds = true
        friendLogo.layer.borderWidth = 2
        friendLogo.layer.borderColor = UIColor.white.cgColor
        
   
   }
    
    public func configue(with friend: User) {
        
        var  url_photo = ""
        if  friend.photo_50 != "https://vk.com/images/camera_50.png", url_photo == "" {
             url_photo = friend.photo_50
        }
        if  friend.photo_100 != "https://vk.com/images/camera_100.png", url_photo == "" {
            url_photo = friend.photo_100
        }
        if  friend.photo_200 != "https://vk.com/images/camera_200.png", url_photo == "" {
            url_photo = friend.photo_200
        }
        if  friend.photo_400_orig != "https://vk.com/images/camera_400.png", url_photo == "" {
            url_photo = friend.photo_400_orig
        }
        if url_photo != "" {
        friendLogo.kf.setImage(with: URL(string: url_photo))
        }
        friendName.text = friend.descrip
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
