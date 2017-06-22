//
//  PrepareLevelView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

enum PrepareTitleDirection: String {
    case Left = "Left"
    case Right = "Right"

}

class PrepareLevelView: UIView {

    var leftLabel: UILabel!
    var middleButton: UIButton!
    var rightlabel: UILabel!
    
    init(frame: CGRect, btuName: String, titleName: String, direction: PrepareTitleDirection, tag: Int) {
        super.init(frame: frame)
        
        leftLabel = UILabel()
        addSubview(leftLabel)
        middleButton = UIButton()
        addSubview(middleButton)
        rightlabel = UILabel()
        addSubview(rightlabel)
        
        
        [leftLabel, rightlabel].forEach { (label) in
            label?.font = UIFont.systemFont(ofSize: 14)
            label?.textColor = ZZGray
        }
        middleButton.setImage(UIImage(named: btuName), for: .normal)
        if direction == .Right {
            rightlabel.text = titleName
            
        } else {
            leftLabel.text = titleName
            
        }
        middleButton.tag = tag

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFrame() {
        leftLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
        }
        middleButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftLabel.snp.right).offset(0)
            make.width.equalTo(40)
        }
        
        rightlabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.left.equalTo(middleButton.snp.right).offset(5)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        leftLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
        }
        middleButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(leftLabel.snp.right).offset(5)
            make.width.equalTo(40)
        }
        
        rightlabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.left.equalTo(middleButton.snp.right).offset(5)
        }
    }

}
