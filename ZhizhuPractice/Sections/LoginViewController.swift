//
//  LoginViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    // 手机号
    @IBOutlet weak var telTextField: UITextField!
    // 密码
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = ZZMainGreen
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ZZWhiteBackground]
        self.title = "登录"
        codeTextField.isSecureTextEntry = true
        [telTextField, codeTextField].forEach { (tf) in
            tf?.delegate = self
        }
    }


    func fetchData() {
        ServerProvider<AccountServer>().requestReturnDictionary(target: .login(username: telTextField.text!, password: codeTextField.text!)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success {
                if status == 200 {
                    // 登录成功
                    // 存储个人信息
                    let resultObject: JSON = JSON(info)["resultObject"]
                    let user_detail: JSON = resultObject["user_detail"]
                    if user_detail["name"].stringValue == "" {
                        UserDefaults.standard.set("" , forKey: AppKeys.UserRealName)
                    } else {
                        UserDefaults.standard.set(user_detail["name"].stringValue , forKey: AppKeys.UserRealName)
                    }
                    if user_detail["nickname"].stringValue == "" {
                        UserDefaults.standard.set("" , forKey: AppKeys.UserNickName)
                    } else {
                        UserDefaults.standard.set(user_detail["nickname"].stringValue , forKey: AppKeys.UserNickName)
                    }
                    
                    UserDefaults.standard.set(user_detail["username"].stringValue, forKey: AppKeys.UserName)
                    UserDefaults.standard.set(user_detail["telephone"].stringValue, forKey: AppKeys.UserTel)
                    UserDefaults.standard.set(user_detail["classId"].stringValue, forKey: AppKeys.UserClassId)
                    UserDefaults.standard.set(user_detail["id"].stringValue, forKey: AppKeys.UserId)
                    UserDefaults.standard.set(user_detail["schoolId"].stringValue, forKey: AppKeys.UserSchoolId)
                    UserDefaults.standard.set(user_detail["schoolName"].stringValue, forKey: AppKeys.UserSchoolName)
                    UserDefaults.standard.set(user_detail["photoUrl"].stringValue, forKey: AppKeys.UserphotoUrl)
                    UserDefaults.standard.set(resultObject["token"].stringValue, forKey: AppKeys.UserToken)
                    self.getCurrentPlanId()
                    self.getCurrentData()
                    


                    
                } else {
                    let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
        }

    }
    
    // 获取当前实习计划阶段
    func getCurrentData() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCurrentStage) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                UserDefaults.standard.set(JSON(info)["resultObject"].stringValue, forKey: AppKeys.CurrentStage)
                NotificationCenter.default.post(name: AppNoti.CheckLoginState, object: nil)
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }
    
    // 查询当前实习计划id
    func getCurrentPlanId() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getExercitationByUserId(userId: AppKeys.getUserId())) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success {
                let planId = JSON(info)["resultObject"]["id"].stringValue
                UserDefaults.standard.set(planId, forKey: AppKeys.PlanId)
                let planName = JSON(info)["resultObject"]["planName"].stringValue
                UserDefaults.standard.set(planName, forKey: AppKeys.PlanName)
            
            }
        }
    }

    
    //MARK: 登录
    @IBAction func LoginAction(_ sender: UIButton) {
        if telTextField.text == "" {
            let vc = RemindViewController(title: "请输入手机号", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return

        }
        if (telTextField.text?.characters.count)! != 11 &&
            !(telTextField.text?.characters.count == 9 && (telTextField.text?.hasPrefix("999"))!) {
            let vc = RemindViewController(title: "手机号格式错误")
            self.present(vc, animated: true, completion:nil)
            return
        }

        if codeTextField.text == "" {
            let vc = RemindViewController(title: "请输入密码", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        fetchData()
        
       
        
        
    }
    
    //MARK:忘记密码
    @IBAction func forgetCodeAction(_ sender: UIButton) {
        let vc = ForgetPasswordViewController()
        vc.pageType = .ForgetPassword
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        [telTextField, codeTextField].forEach { (textField) in
            textField?.resignFirstResponder()
        }
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.characters.count == 11 {
//            codeTextField.becomeFirstResponder()
        }
        return true
    }
}
