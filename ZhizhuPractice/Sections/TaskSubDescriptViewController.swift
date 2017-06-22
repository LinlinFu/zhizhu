//
//  TaskSubDescriptViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskSubDescriptViewController: BaseViewController {

    var dataModel: TaskDetailModel!
    var alertView: ZZAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dataModel != nil {
            if self.dataModel.descript == "" {
                buildNoneLogUI()
            } else {
                
            }
        }
        
        
    }
    
    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 100, y: 20, width: ZZScreenWidth - 200, height: 0), title: "温馨提示", detailTitle: "任务描述暂无内容", type: .Simple)
        view.addSubview(alertView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
