//
//  TaskViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskViewController: WMPageController {

    let controllerArray = [TaskApplyViewController(), TaskImplementViewController()]
    let titleArray = ["任务申请", "任务实施"]
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
    override func viewDidLoad() {
        
        self.title = "实习任务"
        setupUI()
        super.viewDidLoad()
        
    }

    
    func setupUI() {
        self.menuItemWidth = 100; //每个 MenuItem 的宽度
        self.menuBGColor = ZZWhiteBackground
        self.menuViewStyle = .line//这里设置菜单view的样式
        self.progressHeight = 1 //下划线的高度，需要WMMenuViewStyleLine样式
        self.progressColor = ZZMainGreen//设置下划线(或者边框)颜色
        self.titleSizeSelected = 14//设置选中文字大小
        self.titleColorSelected = ZZMainGreen//设置选中文字颜色
        self.titleSizeNormal = 14
        self.selectIndex = 0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //设置viewcontroller的个数
    override func numbersOfChildControllers(in pageController: WMPageController!) -> Int {
        return 2
    }
    //设置对应的viewcontroller
    override func pageController(_ pageController: WMPageController!, viewControllerAt index: Int) -> UIViewController! {
        return controllerArray[index]
    }
    //设置每个viewcontroller的标题
    override func pageController(_ pageController: WMPageController!, titleAt index: Int) -> String! {
        return titleArray[index]
    }
    
    
//    override func pageController(_ pageController: WMPageController!, lazyLoad viewController: UIViewController!, withInfo info: [AnyHashable : Any]!) {
//        
//    }
}

extension TaskViewController {
    
}
