//
//  TaskApplyListCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskApplyListCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //任务申请
    func updateApplyData(model: TaskApplyListModel) {
        nameLabel.text = model.name
        timeLabel.text = "起止时间:\(ZZHelper.timeFormat(timeStamp: model.startTime, format: "yyyy/MM/dd"))-" + "\(ZZHelper.timeFormat(timeStamp: model.endTime, format: "yyyy/MM/dd"))"
        switch model.status {
        case 0:
            statusLabel.text = "未审核"
            statusLabel.textColor = ZZOrangeText
        case 1:
            statusLabel.text = "审核通过"
            statusLabel.textColor = ZZDarkGreenText
        case -2:
            statusLabel.text = "审核不通过"
            statusLabel.textColor = ZZOrangeText
        default:
            break
        }
    }
    
    //任务实施
    func updateImplementData(model: TaskApplyListModel) {
        nameLabel.text = model.name
        timeLabel.text = "起止时间:\(ZZHelper.timeFormat(timeStamp: model.startTime, format: "yyyy/MM/dd"))-" + "\(ZZHelper.timeFormat(timeStamp: model.endTime, format: "yyyy/MM/dd"))"
        switch model.status {
        case 1:
            statusLabel.text = "已批阅"
            statusLabel.textColor = ZZDarkGreenText

        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
