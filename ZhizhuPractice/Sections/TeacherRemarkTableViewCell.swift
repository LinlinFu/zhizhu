//
//  TeacherRemarkTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TeacherRemarkTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var remarkContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func updateRemark(model: LogWeekDetailModel) {
        let score = model.score ?? ""
        scoreLabel.text = "评分: \(score)"
        remarkContent.text = model.remarks ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
