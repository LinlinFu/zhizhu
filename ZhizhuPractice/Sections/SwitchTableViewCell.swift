//
//  SwitchTableViewCell.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/18.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var setTextLabel: UILabel!
    
    @IBOutlet weak var setSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .none
        self.selectionStyle = .none
        setSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }

    func updateDate(row: Int, titleArray: [String]) {
        setTextLabel.text = titleArray[row]
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func ChangeSwitchValue(_ sender: UISwitch) {
        
        let net = ZZHelper.isAllowNotWiFi()
        UserDefaults.standard.set(!net, forKey: AppKeys.NetworkStatus)
        print(ZZHelper.isAllowNotWiFi())
        
        
    }
    
}
