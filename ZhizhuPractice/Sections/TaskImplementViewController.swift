//
//  TaskImplementViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskImplementViewController: BaseViewController {

    var alertView: ZZAlertView!
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ZZWhiteBackground
        buildNoneLogUI()
    }

    
    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 70, y: 20, width: ZZScreenWidth - 140, height: 0), title: "温馨提示", detailTitle: "请在PC端进行实施填写与修改", type: .Simple)
        view.addSubview(alertView)
    }
    
    func fetchData() {
        if isCurrentPlan {
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   }
