//
//  NormalTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class NormalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    // 工地情况反馈
    func updateFeekbackData(topString: String, model: FeekbackModel, indexpath: IndexPath) {
        leftLabel.text = topString
        rightLabel.text = PrepareManager().returnRightText(topString: topString, model: model)
        
    }
    
    // 实习报道
    func updateReportData(topString: String, model: ReportModel, indexpath: IndexPath) {
        leftLabel.text = topString
        switch indexpath.section {
        case 0:
            switch indexpath.row {
            case 0:
                rightLabel.text = ZZHelper.timeFormat(timeStamp: model.reportTime, format: "yyyy/MM/dd")
            case 1:
                rightLabel.text = "\(model.workingStartTime!)-\(model.workingEndTime!)"
            default:
                return
            }
        case 1:
            switch indexpath.row {
            case 0:
                switch model.auditRecordList[0].status {
                case 1:
                    rightLabel.text = "审核通过"
                default:
                    rightLabel.text = "暂无明确结果"
                }
            case 1:
                rightLabel.text = ZZHelper.timeFormat(timeStamp: model.auditRecordList[0].auditTime, format: "yyyy/MM/dd")
            default:
                return
            }
        default:
            return
        }
    }
    
    // 实习计划
    func updatePlanData(model: PlanListModel) {
        leftLabel.text = model.planName
        var statusName = ""
        switch model.status {
        case 0:
            statusName = "进行中"
        case 1:
            statusName = "已结束"
        default:
            statusName = "状态未确定"
        }
        rightLabel.text = statusName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
