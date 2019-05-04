//
//  ConteinerView.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 20/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit


 @IBDesignable class CornerAvatar: UIImageView{
    private var cornerLayer: CAShapeLayer!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    

    @IBInspectable var cornerRadius: CGFloat = 21 {
        didSet {
            setNeedsDisplay()
        }
    }


    
override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    if cornerLayer == nil {
        cornerLayer = CAShapeLayer()
        
        cornerLayer.borderWidth = 2.0
        cornerLayer.borderColor = UIColor.black.cgColor
        cornerLayer.cornerRadius = cornerRadius//self.frame.size.width / 2
        
        cornerLayer.masksToBounds = true
        
        layer.addSublayer(cornerLayer)
    }
}
}
