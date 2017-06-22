//
//  UploadFilesViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/9.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class UploadFilesViewController: BaseViewController {

    
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "上传附件"
    }

    
    //AMRK:
    func fetchData() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
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
