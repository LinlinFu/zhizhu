//
//  ZZAlertView.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit


enum AlertViewType {
    case Simple // 简单的 height=50
    case Complex // 复杂的 height=60
}
class ZZAlertView: UIView {

    
    var warningImage: UIImageView!
    var titleLabel: UILabel!
    var detailTitleLabel: UILabel!
    var viewHeight: CGFloat = 0
    
    init(frame: CGRect, title: String, detailTitle: String, type: AlertViewType) {
        switch type {
        case .Simple:
            viewHeight = 40
        default:
            viewHeight = 60
        }
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: viewHeight))
        warningImage = UIImageView()
        warningImage.image = UIImage(named: "warning")
        self.addSubview(warningImage)

    
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        detailTitleLabel = UILabel()
        detailTitleLabel.numberOfLines = 0
        detailTitleLabel.text = detailTitle
        detailTitleLabel.font = UIFont.systemFont(ofSize: 14)
        detailTitleLabel.textColor = ZZGray
        self.addSubview(detailTitleLabel)
        
        layoutSubview()
    }
    
    func layoutSubview() {
        warningImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(viewHeight * 0.66)
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(warningImage.snp.right).offset(10)
        }
        
        detailTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.left)
            make.bottom.right.equalTo(0)
        
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
