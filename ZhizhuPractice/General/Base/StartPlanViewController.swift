//
//  StartPlanViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class StartPlanViewController: BaseViewController {

    
    @IBOutlet weak var planName: UILabel!
    
    @IBOutlet weak var prepareTime: UILabel!
    
    
    @IBOutlet weak var processTime: UILabel!
    
    
    @IBOutlet weak var summaryTime: UILabel!
    
    
    var modelArray: [SubTimesModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "知筑实习"
//        getCurrentPlanId()
        self.planName.text = AppKeys.getPlanName()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    // 查询当前实习计划id
//    func getCurrentPlanId() {
//        ServerProvider<ReportServer>().requestReturnDictionary(target: .getExercitationByUserId(userId: AppKeys.getUserId())) { (success, info) in
//            guard let info = info else {
//                let vc = RemindViewController(title: "网络异常", type: .failure)
//                self.present(vc, animated: true, completion: nil)
//                return
//            }
//            if success {
//                let planId = JSON(info)["resultObject"]["id"].stringValue
//                UserDefaults.standard.set(planId, forKey: AppKeys.PlanId)
//                let planName = JSON(info)["resultObject"]["planName"].stringValue
//                UserDefaults.standard.set(planName, forKey: AppKeys.PlanName)
//                self.planName.text = AppKeys.getPlanName()
//            }
//        }
//    }

    // 查询实习计划时间
    func fetchData() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getStageTime) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                
                let resultObject = JSON(info)["resultObject"].arrayValue
                for model in resultObject {
                    let data = SubTimesModel(json: model)
                    self.modelArray.append(data)
                }
                self.prepareTime.text = "\(ZZHelper.timeFormat(timeStamp: self.modelArray[0].startTime, format: "yyyy-MM-dd")) -" + "\(ZZHelper.timeFormat(timeStamp: self.modelArray[0].endTime, format: "yyyy-MM-dd"))"
                self.processTime.text = "\(ZZHelper.timeFormat(timeStamp: self.modelArray[1].startTime, format: "yyyy-MM-dd")) -" + "\(ZZHelper.timeFormat(timeStamp: self.modelArray[2].endTime, format: "yyyy-MM-dd"))"
                self.summaryTime.text = "\(ZZHelper.timeFormat(timeStamp: self.modelArray[2].startTime, format: "yyyy-MM-dd")) -" + "\(ZZHelper.timeFormat(timeStamp: self.modelArray[2].endTime, format: "yyyy-MM-dd"))"
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }

    
    // 改变当前的Stage
        func gotoNextStage() {
    
            ServerProvider<PrepareServer>().requestReturnDictionary(target: .gotoNextStage(stage: "STAGE11_MOBILIZATION")) { (success, info) in
                guard let info = info else {
                    let vc = RemindViewController(title: "网络异常", type: .failure)
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                if success && JSON(info)["status"].intValue == 200 {
                    UIApplication.shared.keyWindow?.rootViewController = BaseTabBarViewController()

    
                } else {
                    let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                    self.present(vc, animated: true, completion: nil)
                    
                }
            }
    
        }
    
    
    // 进入下一阶段
    @IBAction func joinAction(_ sender: UIButton) {
        gotoNextStage()
        
    }
   
}
