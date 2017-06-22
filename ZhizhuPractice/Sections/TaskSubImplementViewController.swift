//
//  TaskSubImplementViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskSubImplementViewController: BaseViewController {

    var dataModel: TaskImplementDetailModel!
    var alertView: ZZAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataModel != nil {
            if self.dataModel.fileList.count == 0 {
                buildNoneLogUI()
            } else {
                
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 100, y: 20, width: ZZScreenWidth - 200, height: 0), title: "温馨提示", detailTitle: "任务实施暂无内容", type: .Simple)
        view.addSubview(alertView)
    }
    


}
