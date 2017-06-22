//
//  NoticeTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet weak var noticeImage: UIImageView!
    
    @IBOutlet weak var noticeType: UILabel!
    
    @IBOutlet weak var noticeDetail: UILabel!
    
    @IBOutlet weak var noticeTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 修改多选模式下选中按钮的图片
        for control in self.subviews {
            if control.isMember(of: NSClassFromString("UITableViewCellEditControl")!) {
                for v in control.subviews {
                    if v.isKind(of: UIImageView.self) {
                        let img = v as! UIImageView
                        if isSelected {
                            img.image = UIImage(named: "circle_right")
                        } else {
                            img.image = UIImage(named: "circle_hole_gray")
                        }
                    }
                }
            }
        }

        
    }
    
    func updateData(model: RemindModel) {
        noticeType.text = model.sendUserNickname
        noticeDetail.text = model.title
        noticeTime.text = ZZHelper.timeFormat(timeStamp: model.createTime, format: "yyyy-MM-dd")
        if model.selected {
            noticeType.textColor = ZZGray
        } else {
            noticeType.textColor = ZZBlack
        }
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
