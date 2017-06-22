//
//  ExamTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ExamTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var optionLabel: UILabel!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        bottomView.layer.borderColor = ZZMainLineGray.cgColor
        bottomView.layer.borderWidth = 1
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if selected {
//            selectedImageView.image = UIImage(named: "selected_right")
//            bottomView.backgroundColor = ZZLightGrayBg_F7F7F7
//        } else {
//            selectedImageView.image = UIImage()
//            bottomView.backgroundColor = ZZWhiteBackground
//        }
    }
    
}
