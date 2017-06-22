//
//  ExamHeaderView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ExamHeaderView: UITableViewHeaderFooterView {

    var bottomView: UIView!
    var label: UILabel!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bottomView = UIView()
        label = UILabel()
        contentView.addSubview(bottomView)
        bottomView.addSubview(label)
        self.contentView.backgroundColor = ZZWhiteBackground
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomView.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(0)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
