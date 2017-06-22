//
//  FeedbackNormalCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class FeedbackNormalCell: UITableViewCell {

    
    @IBOutlet weak var leftLabel: UILabel!
    
    @IBOutlet weak var rightTextField: UITextField!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // 工地情况反馈
    func updateFeekbackData(topString: String, model: FeekbackModel, indexpath: IndexPath) {
        
        
        leftLabel.text = topString
        let detailData:(String, Bool, Bool) = PrepareManager().returnDetailData(topString: topString, model: model)
        rightLabel.isHidden = detailData.2
        rightTextField.isHidden = detailData.1
        if rightTextField.isHidden {
            rightLabel.text = detailData.0
        } else {
            rightTextField.text = detailData.0
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
