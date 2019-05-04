//
//  AllGroupsCellTableViewCell.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 12/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
import Kingfisher

class AllGroupsCellTableViewCell: UITableViewCell {

    @IBOutlet weak var allGroupName: UILabel!
    @IBOutlet weak var allGroupLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configue(with group: Group) {
        
        allGroupLogo.kf.setImage(with: URL(string: group.photo_50))
        allGroupName.text = group.name
        

        
    }
    
}
