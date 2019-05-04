//
//  ShadowView.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 19/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit



@IBDesignable class ShadowView: UIView {
    
     private var shadowLayer: CAShapeLayer!
     // var cornerRadius: CGFloat = 20
    
    @IBInspectable var viewBackgroundColor: UIColor = .clear {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
   
    
    
    @IBInspectable var shadowRadius: CGFloat = 22 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            setNeedsDisplay()
        }
    }


    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            //shadowLayer.cornerRadius = cornerRadius//bounds.height/2
            shadowLayer.masksToBounds = false
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
            shadowLayer.fillColor = viewBackgroundColor.cgColor
            
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            
            layer.addSublayer(shadowLayer)
        }
    }
}
