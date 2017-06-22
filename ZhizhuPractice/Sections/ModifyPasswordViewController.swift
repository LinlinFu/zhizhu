//
//  ModifyPasswordViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/19.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ModifyPasswordViewController: BaseViewController {

    
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var surePassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        [currentPassword, newPassword, surePassword].forEach { (textfield) in
            textfield?.isSecureTextEntry = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    //MARK:提交并登录
    
    @IBAction func sureAction(_ sender: UIButton) {
        print(AppKeys.getUserToken())
        if currentPassword.text == "" || newPassword.text == "" || surePassword.text == "" {
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
    
    func fetchData() {
        let param: [String: AnyObject] = ["oldPassword": currentPassword.text as AnyObject,
                                          "newPassword": newPassword.text as AnyObject,
                                          "type": 2 as AnyObject]
        ServerProvider<AccountServer>().requestReturnDictionary(target: .updatePassowrd(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].stringValue
            if success && status == "200" {
                let vc = RemindViewController(title: JSON(info)["修改成功,请重新登录"].stringValue, type: .success)
                self.present(vc, animated: true, completion: nil)
                ZZHelper.clearUserData()
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        [currentPassword, newPassword, surePassword].forEach { (textfield) in
            textfield?.resignFirstResponder()
        }
    }
    
}
