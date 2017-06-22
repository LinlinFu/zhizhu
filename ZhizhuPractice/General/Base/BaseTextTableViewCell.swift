//
//  BaseTextTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/9.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class BaseTextTableViewCell: UITableViewCell {

    //
   var  contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentLabel = UILabel()
        contentView.addSubview(contentLabel)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.equalTo(-15)
            
        }
    }

}
