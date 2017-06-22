//
//  AboutUsViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/18.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    // contentLabel
    var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        contentLabel = UILabel()
        view.addSubview(contentLabel)
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 0
        contentLabel.text = "    知筑实习是由杭州万霆科技股份有限公司针对建筑专业院校研发的一款实习管理产品。产品涵盖了岗前准备、实习进行、实习考核三个主要阶段，以及打卡签到、实习任务、实习报告等一系列人性化的实习功能。在保证实习正常的前提下，满足对学生实习安全监管、实习任务灵活配置、相关通知的下达等，实习结束后能自动生成考核报告，是建筑院校实践教学理想的配套产品。"
        contentLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.equalTo(-5)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
