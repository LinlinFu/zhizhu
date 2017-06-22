//
//  TaskApplyViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskApplyViewController: BaseViewController {

    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    var alertView: ZZAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ZZWhiteBackground
        buildNoneLogUI()
    }
    
    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 70, y: 20, width: ZZScreenWidth - 140, height: 0), title: "温馨提示", detailTitle: "请在PC端进行任务申报与修改", type: .Simple)
        view.addSubview(alertView)
    }
    
    func fetchData() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    


}
