//
//  NewsTableAction_Eyes.swift
//  VK_lesson_2
//
//  Created by Чернецова Юлия on 03/05/2019.
//  Copyright © 2019 Чернецов Роман. All rights reserved.
//

import UIKit
class NewsTableAction_Eyes: UIControl{
    
    private let width: CGFloat = 30.0
    private let height: CGFloat = 30.0
    private let margin: CGFloat = 3.0
    private var counter: Int = 0
    
    var eyesView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 30.0, height: 30.0)))
    var eyesButtom = UIButton(type: .custom)
    lazy var eyesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25.0)
        label.text = String(counter)
        return label
    }()
    
    private var isLiked = false {
        didSet{
            eyesLabel.text = String(counter)
            if oldValue == false {
                eyesLabel.textColor = UIColor.red
            } else {
                eyesLabel.textColor = UIColor.black
            }
        }
    }
    private func setupView(){
        eyesButtom.setImage(UIImage(named: (isLiked == true ? "eye": "eye")), for: .normal)
        eyesButtom.addTarget(self, action: #selector(eyesAction), for: .touchUpInside)
        self.addSubview(eyesView)
        self.eyesView.addSubview(eyesButtom)
        self.eyesView.addSubview(eyesLabel)
    }
    @objc func eyesAction(){
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
        eyesView.frame = bounds
        eyesButtom.frame = CGRect(origin: .zero, size: CGSize(width: width+margin+3, height: height))
        eyesLabel.frame = CGRect(x: eyesButtom.frame.width, y: 0, width: width+margin+3, height: height)
        
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
