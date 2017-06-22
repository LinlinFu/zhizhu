//
//  ReportTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/18.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var reportTitle: UILabel!
    
    @IBOutlet weak var completeStatus: UILabel!
    
    @IBOutlet weak var currentStatus: UIButton!

    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var widthScale: NSLayoutConstraint!
    
    @IBOutlet weak var widthOfImage: NSLayoutConstraint!
    
    @IBOutlet weak var linView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.masksToBounds = true
        iconImage.image = UIImage(named: "userImage")
        
    }
    
    // "实习报告"
    func updateCellData(dayModel: AllPracticeStatusModel, timeModel: AllExercitationTimesModel, topString: String) {
        linView.isHidden = true
        reportTitle.text = topString
        var data = (content: "", image: "", rightText: "")
        data = ReportManager().updateData(dayModel: dayModel, timeModel: timeModel, topString: topString)
        iconImage.image = UIImage(named: data.image)
        completeStatus.text = data.content
        currentStatus.setTitle(data.rightText, for: .normal)
        currentStatus.setTitleColor(ZZOrangeText, for: .normal)
    }
    
    // 实习日志 周记
    func updateLogData(model: LogWeekModel) {
        widthScale.priority = 600
        widthOfImage.priority = 800
        iconImage.image = UIImage()
        leftMargin.constant = 0
        let sort = String(model.sort)
        reportTitle.text = "第\(sort)篇"
        completeStatus.text = ZZHelper.timeFormat(timeStamp: model.createTime, format: "yyyy/MM/dd")
        if model.remarks == "" {
            currentStatus.setTitle("待批阅", for: .normal)
            currentStatus.setTitleColor(ZZOrangeText, for: .normal)
        } else {
            currentStatus.setTitle("已批阅", for: .normal)
            currentStatus.setTitleColor(ZZDarkGreenText, for: .normal)
        }
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
