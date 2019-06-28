//
//  NewsLikeControl.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 30/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//
import UIKit
 class NewsLikeControl: UIControl{
    
    private let width: CGFloat = 30.0
    private let height: CGFloat = 30.0
    private let margin: CGFloat = 3.0
    private var counter: Int = 0
    
     var likeView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)))
     var likeButtom = UIButton(type: .custom)
     lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.text = String(counter)
        return label
    }()
    
    private var isLiked = false {
        didSet{
            likeLabel.text = String(counter)
            if oldValue == false {
                likeLabel.textColor = UIColor.red
            } else {
                likeLabel.textColor = UIColor.black
            }
        }
    }
    private func setupView(){
        likeButtom.setImage(UIImage(named: (isLiked == true ? "liked": "notliked")), for: .normal)
        likeButtom.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
        self.addSubview(likeView)
        self.likeView.addSubview(likeButtom)
        self.likeView.addSubview(likeLabel)
    }
    @objc func likeAction(){
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
        likeView.frame = bounds
        likeButtom.frame = CGRect(origin: .zero, size: CGSize(width: width+margin+3, height: height))
        likeLabel.frame = CGRect(x: likeButtom.frame.width, y: 0, width: width+margin+3, height: height)
        
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
