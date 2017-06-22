//
//  TaskSubFileViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskSubFileViewController: BaseViewController {

    
    var dataModel: TaskDetailModel!
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

    }
    
    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 100, y: 20, width: ZZScreenWidth - 200, height: 0), title: "温馨提示", detailTitle: "任务附件暂无内容", type: .Simple)
        view.addSubview(alertView)
    }
    

 

}
