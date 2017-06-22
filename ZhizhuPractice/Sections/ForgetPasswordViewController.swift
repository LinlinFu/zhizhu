//
//  ForgetPasswordViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/23.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

enum UpdatePasswordType {
    case OldPhone //修改手机(旧手机号)
    case NewPhone //修改手机(新手机号)
    case ForgetPassword //忘记密码
}

class ForgetPasswordViewController: BaseViewController {

    @IBOutlet weak var telLabel: UILabel!
    
    @IBOutlet weak var telTextField: UITextField!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var getCodeButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    //页面类型
    var pageType: UpdatePasswordType = .OldPhone
    //判断code是否完成输入
    var codeFinshed: Bool = false
    // 定时器
    var timer: Timer!
    // 验证码倒计时
    var remainingSeconds: Int = 0 {
        willSet {
            if newValue <= 0 {
                isCounting = false
            } else {
                getCodeButton.setTitle("\(newValue)S", for: .disabled)
            }
        }
    }
    var isCounting: Bool = false {
        willSet {
            if newValue {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                remainingSeconds = 59
                getCodeButton.isEnabled = false
            } else {
                timer.invalidate()
                timer = nil
                getCodeButton.isEnabled = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [telTextField, codeTextField].forEach { (tf) in
            tf?.delegate = self
        }
        switch pageType {
        case .NewPhone:
            nextButton.setTitle("提交", for: .normal)
            telLabel.text = "新手机号"
            self.title = "修改手机"
        case .ForgetPassword:
            self.title = "找回密码"
            return
        default:
            self.title = "修改手机"
            return
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func getCodeAction(_ sender: UIButton) {
        print("获取验证码")
        if (telTextField.text?.characters.count)! != 11 &&
            !(telTextField.text?.characters.count == 9 && (telTextField.text?.hasPrefix("999"))!) {
            let vc = RemindViewController(title: "手机号格式错误")
            self.present(vc, animated: true, completion:nil)
            return
        }
        
        fetchDataAboutGetCode()
    }

    func timerAction() {
        remainingSeconds -= 1

    }
    @IBAction func nextAction(_ sender: UIButton) {
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
            let vc = RemindViewController(title: "请输入验证码", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        fetchData()
        
    }
    

    //MARK:获取验证码
    func fetchDataAboutGetCode() {
        var param: [String: AnyObject] = [:]
        switch pageType {
        case .ForgetPassword:
            param = ["telephone": telTextField.text! as AnyObject, "codeType": "FORGOTPASSWORD" as AnyObject]
        case .OldPhone:
            param = ["telephone": telTextField.text! as AnyObject, "codeType": "MODIFYPHONE" as AnyObject, "checkTel": true as AnyObject]
        case .NewPhone:
            param = ["telephone": telTextField.text! as AnyObject, "codeType": "CONFIRMMODIFYPHONE" as AnyObject, "checkNewTelIsOri": true as AnyObject, "isUpdateTelephone": true as AnyObject]
        }
        // 网络请求成功后启动倒计时
        isCounting = true
        ServerProvider<AccountServer>().requestReturnDictionary(target: .sendCode(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title:"网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                let vc = RemindViewController(title:"验证码已发送,请注意查收!", type: .success)
                self.present(vc, animated: true, completion: nil)
            } else {
                let vc = RemindViewController(title:JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }

    //MARK: 下一步请求/提交
    func fetchData() {
        var param: [String: AnyObject] = [:]
        switch pageType {
        case .ForgetPassword:
            param = ["telephone": telTextField.text! as AnyObject, "code": codeTextField.text!as AnyObject, "codeType": "FORGOTPASSWORD" as AnyObject]
        case .OldPhone:
            param = ["telephone": telTextField.text! as AnyObject, "code": codeTextField.text!as AnyObject, "codeType": "MODIFYPHONE" as AnyObject, "checkTel": true as AnyObject]
        case .NewPhone:
            param = ["telephone": telTextField.text! as AnyObject, "code": codeTextField.text!as AnyObject, "codeType": "CONFIRMMODIFYPHONE" as AnyObject,"checkNewTelIsOri": true as AnyObject ,"isUpdateTelephone": true as AnyObject]
        }
        ServerProvider<AccountServer>().requestReturnDictionary(target: .sureCode(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title:"网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                switch self.pageType {
                case .ForgetPassword:
                    let vc = SureCodeViewController()
                    vc.tel = self.telTextField.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case .OldPhone:
                    let vc = ForgetPasswordViewController()
                    vc.pageType = .NewPhone
                    self.navigationController?.pushViewController(vc, animated: true)
                case .NewPhone:
                    let vc = RemindViewController(title:"修改成功", type: .success)
                    self.present(vc, animated: true, completion: nil)
                    ZZHelper.clearUserData()
                }
                
            } else {
                let vc = RemindViewController(title:JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        [telTextField, codeTextField].forEach { (tf) in
            tf?.resignFirstResponder()
        }
    }
    
}

extension ForgetPasswordViewController: UITextFieldDelegate {

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
//        print("currentText\(currentText)")
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        print("newText\(newText)")
        if textField == codeTextField && newText.characters.count >= 4 {
            if timer != nil {
            isCounting = false
            }
        }
        return true
    }
}
