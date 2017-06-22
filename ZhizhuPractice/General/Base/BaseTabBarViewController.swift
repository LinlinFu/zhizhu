//
//  BaseTabBarViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ZZWhiteBackground
        addViewControllers()
        
    }
    
    // 添加子控制器
    func addViewControllers() {
        let vcArray = [PrepareViewController(), SignViewController(), ReportViewController(), MineViewController()]
        let navigationTitleArr = ["实习准备", "签到", "实习报告", "个人信息"]
        let titleArray = ["准备", "签到", "报告", "我的"]
        for i in 0..<4 {
            let image = "tab_\(i)"
            let image_select = "tab_select_\(i)"
            addChildVC(childVC: vcArray[i], navigationTitle: navigationTitleArr[i], title: titleArray[i], image: image, image_select: image_select)
        }
        
    }


    func addChildVC(childVC: UIViewController, navigationTitle: String, title: String, image: String, image_select: String) {
        childVC.navigationItem.title = navigationTitle
        childVC.tabBarItem.title = title
        childVC.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: image_select)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: ZZMainGreen], for: .selected)
        addChildViewController(BaseNavigationController(rootViewController: childVC))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 
}
