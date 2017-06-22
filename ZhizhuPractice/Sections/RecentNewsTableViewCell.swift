//
//  RecentNewsTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class RecentNewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var detailContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }
    
    func updateRecentData(model: RecentStatusModel) {
        timeLabel.text = model.createTime
        detailContent.text = model.descript
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

