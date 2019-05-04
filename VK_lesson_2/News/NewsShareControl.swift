//
//  NewsShareControl.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 30/01/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//
import UIKit
class NewsShareControl: UIControl{
    
    private let width: CGFloat = 30.0
    private let height: CGFloat = 30.0
    private let margin: CGFloat = 3.0
    private var counter: Int = 0
    
     var shareView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)))
     var shareButtom = UIButton(type: .custom)
     lazy var shareLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30.0)
        label.text = String(counter)
        return label
    }()
    
    private var isLiked = false {
        didSet{
            shareLabel.text = String(counter)
            if oldValue == false {
               shareLabel.textColor = UIColor.red
            } else {
                shareLabel.textColor = UIColor.black
            }
        }
    }
    private func setupView(){
        shareButtom.setImage(UIImage(named: (isLiked == true ? "share": "share")), for: .normal)
        shareButtom.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        self.addSubview(shareView)
        self.shareView.addSubview(shareButtom)
        self.shareView.addSubview(shareLabel)
    }
    @objc func shareAction(){
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
        shareView.frame = bounds
        shareButtom.frame = CGRect(origin: .zero, size: CGSize(width: width+margin+3, height: height))
        shareLabel.frame = CGRect(x: shareButtom.frame.width, y: 0, width: width+margin+3, height: height)
        
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
