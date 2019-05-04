//
//  Ext_ImageView.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 24/04/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import Foundation
import  UIKit
extension UIImageView {
    //If you want only round corners
    func imgViewCorners() {
        layer.cornerRadius = 10
        layer.borderWidth = 1.0
        layer.masksToBounds = true
    }
}
