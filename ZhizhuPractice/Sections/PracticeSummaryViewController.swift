//
//  PracticeSummaryViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/7.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class PracticeSummaryViewController: BaseViewController {

    var alertView: ZZAlertView!
    var planId = ""
    var isCurrentPlan = true
    var dataModel: PracticeSummaryModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实习总结"
        buildNoneLogUI()
        getSummaryContent()
        
    }
    
    func buildNoneLogUI() {
        var finalTitle = "没有查到您的总结信息"
        if isCurrentPlan {
            finalTitle = "请在PC端填写提交"
        }
        alertView = ZZAlertView(frame: CGRect(x: 80, y: 20, width: ZZScreenWidth - 180, height: 0), title: "温馨提示", detailTitle: finalTitle, type: .Simple)
        view.addSubview(alertView)
    }
    
    
    //MARK: 查询实习总结内容
    func getSummaryContent() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getSummaryByPlanIdAndType(type: 2, planId: planId)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && (JSON(info)["status"].stringValue == "200") {
                self.dataModel = PracticeSummaryModel(json: JSON(info)["resultObject"])
                if self.dataModel.summary.id != "" {
//                    if self.tableView == nil {
//                        self.buildTableView()
//                    }
//                    self.tableView.reloadData()
                } else {
                    if self.alertView == nil {
                        self.buildNoneLogUI()
                    }
                }
                
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
