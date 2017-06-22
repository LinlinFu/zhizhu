//
//  LogDetailTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class LogDetailTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemTitle: UILabel!
    
    @IBOutlet weak var itemContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func updateLogDetailData(topString: String, model: LogWeekDetailModel, row: Int) {
        itemTitle.text = topString
        switch row {
        case 0:
            itemContent.text = model.descript ?? ""
        case 1:
            itemContent.text = model.practice ?? ""
        case 2:
            itemContent.text = model.standards ?? ""
        default:
            itemContent.text = ""
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
