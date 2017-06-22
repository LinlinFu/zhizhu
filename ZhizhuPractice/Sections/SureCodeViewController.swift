//
//  SureCodeViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class SureCodeViewController: BaseViewController {

    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var surePassword: UITextField!
    
    var tel: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "找回密码"
        [newPassword, surePassword].forEach { (tf) in
            tf?.isSecureTextEntry = true
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //MARK: 提交并登录
    @IBAction func sureAction(_ sender: UIButton) {
        judgeContent()
    }
    
    //MARK: 请求前的判断
    func judgeContent() {
        if newPassword.text == "" || surePassword.text == "" {
            let vc = RemindViewController(title: "请输入密码", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
            
        }
        if ((newPassword.text?.characters.count)! < 6 || (newPassword.text?.characters.count)! > 16) {
            let vc = RemindViewController(title: "请输入6-16位新密码", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
            
        }
        if newPassword.text != surePassword.text {
            let vc = RemindViewController(title: "请核对确认密码", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        fetchData()
        

    }
    
    //MARK: 网络请求
    func fetchData() {
        let param: [String: AnyObject] = ["telephone":tel as AnyObject,
                                          "newPassword": newPassword.text as AnyObject,
                                          "type": 1 as AnyObject]
        ServerProvider<AccountServer>().requestReturnDictionary(target: .updatePassowrd(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title:"网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                let vc = RemindViewController(title:"成功", type: .failure)
                self.present(vc, animated: true, completion: nil)
                //请求成功后调到登录页
//                ZZHelper.userLogout()
                ZZHelper.clearUserData()
            } else {
                let vc = RemindViewController(title:JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        [newPassword, surePassword].forEach { (tf) in
            tf?.resignFirstResponder()
        }
    }
}
