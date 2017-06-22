//
//  BaseNavigationController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    
    var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = ZZMainGreen
        self.navigationBar.tintColor = ZZWhiteBackground
        self.navigationBar.isTranslucent = false
        view.backgroundColor = ZZWhiteBackground
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ZZWhiteBackground]
        // 设置interactivePopGestureRecognizer代理委托
        interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.barStyle = .black
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count != 0 {
            
            // 自定义返回按钮
            let backView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
            
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            backButton.setImage(UIImage(named: "back"), for: .normal)
            backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            
            let backTitle = UILabel(frame: CGRect(x: 20, y: 0, width: 40, height: 20))
            backTitle.isUserInteractionEnabled = true
            backTitle.text = "返回"
            backTitle.textColor = ZZWhiteBackground
            tap = UITapGestureRecognizer(target: self, action: #selector(backAction))
            backTitle.addGestureRecognizer(tap)
            
            backView.addSubview(backButton)
            backView.addSubview(backTitle)
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
            
            //当push时隐藏tabbar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    func backAction() {
        popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

   

}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.childViewControllers.count != 1
    }
}
