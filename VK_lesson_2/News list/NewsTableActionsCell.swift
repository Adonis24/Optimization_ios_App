//
//  NewsTableActionsCell.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 14/04/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit

class NewsTableActionsCell: UITableViewCell {
    
  
    @IBOutlet weak var NewsCommentView: NewsCommentControl!
    
    @IBOutlet weak var NewsLikeView: NewsLikeControl!
    
    @IBOutlet weak var NewsEyesView: NewsEyesControl!
    
    @IBOutlet weak var NewsShareView: NewsShareControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
  
        NewsLikeView.isUserInteractionEnabled = true
        NewsShareView.isUserInteractionEnabled = true
        NewsCommentView.isUserInteractionEnabled =  true
        NewsEyesView.isUserInteractionEnabled    = true
        setupGestureRecognizer(source: NewsLikeView)
        setupGestureRecognizer(source: NewsShareView)
        setupGestureRecognizer(source: NewsCommentView)
        setupGestureRecognizer(source: NewsEyesView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupGestureRecognizer(source:UIView) ->Void {
        let tapGesture  = UITapGestureRecognizer(target: self, action: #selector(tapFoto(sender:)))
        tapGesture.numberOfTapsRequired = 1
        
        source.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapFoto(sender:UIGestureRecognizer){
        switch sender.view {
        // rotation On click like count
        case NewsLikeView:
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = 2
            
            NewsLikeView.likeButtom.layer.add(rotationAnimation, forKey: nil)
        // rotation On click comment count
        case NewsCommentView:
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = 2
            
            NewsCommentView.commentButtom.layer.add(rotationAnimation, forKey: nil)
            // \\rotation On click comment count
        // \\rotation On click share count
        case NewsShareView:
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = 2
            
            NewsShareView.shareButtom.layer.add(rotationAnimation, forKey: nil)
        // \\rotation On click share count
        case NewsEyesView:
            
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = 2
            
            NewsEyesView.eyesButtom.layer.add(rotationAnimation, forKey: nil)
        // \\rotation On click share count
//        case NewsImage:
//            UIView.animate(withDuration: 1,
//                           delay: 0,
//                           options: .curveEaseInOut,
//                           animations: {
//                            self.NewsImage.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            }) { (success: Bool) in
//                UIView.animate(withDuration: 1,
//                               delay: 0,
//                               options: .curveEaseInOut,
//                               animations: {
//                                self.NewsImage.transform = CGAffineTransform.identity
//                })
//            }
        default:
            return
        }
    }
}
