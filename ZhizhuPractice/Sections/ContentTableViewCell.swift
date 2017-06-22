//
//  ContentTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // 工地情况反馈
    func updateFeekbackData(topString: String, model: FeekbackModel, indexpath: IndexPath) {
        topLabel.text = ""
        topMargin.constant = 0
        switch indexpath.section {
        case 4:
            contentLabel.text = model.descript
        case 5:
            contentLabel.text = model.auditRecordList[0].comment
        default:
            return
        }
    }

    // 实习报道
    func updateReportData(topString: String, model: ReportModel, row: Int) {
        topLabel.text = topString
        switch row {
        case 2:
            contentLabel.text = model.workingContent
        case 3:
            contentLabel.text = model.companyRules
        case 4:
            contentLabel.text = model.workingHelp
        default:
            return
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
