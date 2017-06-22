//
//  RemiandHeaderView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/9.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class RemiandHeaderView: UIView {

    var topView: UIView!
    var remindLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 30))
        self.addSubview(topView)
        remindLabel = UILabel(frame: CGRect(x: 15, y: 0, width: topView.bounds.width-15, height: 30))
        topView.addSubview(remindLabel)
        remindLabel.text = "温馨提示: 请在PC端进行修改提交"
        topView.backgroundColor = ZZLightYellowBg
        remindLabel.font = UIFont.systemFont(ofSize: 16)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
