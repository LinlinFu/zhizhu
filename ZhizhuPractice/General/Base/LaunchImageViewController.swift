//
//  LaunchImageViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class LaunchImageViewController: BaseViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppKeys.getUserToken() == "" {
            UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController(rootViewController:LoginViewController())
        } else {
            fetchData()
        }
        
    }
    
    // 获取当前实习计划阶段
    func fetchData() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCurrentStage) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                UIApplication.shared.keyWindow?.rootViewController = BaseTabBarViewController()
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                
                let resultObject = JSON(info)["resultObject"].string
                if resultObject != nil {
                    NotificationCenter.default.post(name: AppNoti.CheckLoginState, object: nil)
                    //                    UIApplication.shared.keyWindow?.rootViewController = BaseTabBarViewController()
                    
                } else {
                    //                    UIApplication.shared.keyWindow?.rootViewController = BaseNavigationController(rootViewController:StartPlanViewController())
                    }
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
