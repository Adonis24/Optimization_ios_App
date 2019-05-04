//
//  LoadView.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 31/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit

class LoadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 20//frame.height/2
        self.contentMode = .center
        self.clipsToBounds = true
        self.layer.backgroundColor   = UIColor.white.cgColor
        self.frame.size.width = 20
        self.frame.size.height = 20
        
    }

    }

