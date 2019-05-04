//
//  NewsTableBodyCell.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 14/04/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit

class NewsTableBodyCell: UITableViewCell {

    @IBOutlet weak var NewsBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
