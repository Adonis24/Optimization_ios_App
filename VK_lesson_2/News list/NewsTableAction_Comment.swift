//
//  NewsTableAction_Comment.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 03/05/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
class NewsTableAction_Comment: UIControl{
    
    
    private let width: CGFloat = 30.0
    private let height: CGFloat = 30.0
    private let margin: CGFloat = 3.0
    private var counter: Int = 0
    
    var commentView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)))
    var commentButtom = UIButton(type: .custom)
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.text = String(counter)
        return label
    }()
    
    private var isLiked = false {
        didSet{
            commentLabel.text = String(counter)
            if oldValue == false {
                commentLabel.textColor = UIColor.red
            } else {
                commentLabel.textColor = UIColor.black
            }
        }
    }
    private func setupView(){
        commentButtom.setImage(UIImage(named: (isLiked == true ? "comment": "comment")), for: .normal)
        commentButtom.addTarget(self, action: #selector(commentAction), for: .touchUpInside)
        self.addSubview(commentView)
        self.commentView.addSubview(commentButtom)
        self.commentView.addSubview(commentLabel)
    }
    @objc func commentAction(){
        if !isLiked {
            counter += 1
            isLiked = true
        } else if isLiked {
            counter -= 1
            isLiked = false
        }
        setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        commentView.frame = bounds
        commentButtom.frame = CGRect(origin: .zero, size: CGSize(width: width+margin+3, height: height))
        commentLabel.frame = CGRect(x: commentButtom.frame.width, y: 0, width: width+margin+3, height: height)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}
