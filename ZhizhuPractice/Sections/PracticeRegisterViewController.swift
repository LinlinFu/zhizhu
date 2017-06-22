//
//  PracticeRegisterViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class PracticeRegisterViewController: BaseViewController {
    
    var tableView: UITableView!
    var firstArray = ["实习时间", "实习单位", "所在地区", "详细地址"]
    var secondArray = ["审核结果", "审核时间"]
    var infoModel: RegisterModel!
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    // 是否可以编辑
    var canEdit = false
    
    // 选择器
    var alertView: ZZPickerView!
    
    // 起止时间
    var startTime = ""
    var endTime = ""
    // 实习单位
    var company = ""
    // 所在地区
    var address = ""
    // 详细地址
    var detailAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实习计划登记"
        buildTableView()
        if canEdit {
            buildRightButton()
        } else {
            fetchRegisterList()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if alertView != nil {
            alertView.removeFromSuperview()
        }
    }
    
    func buildRightButton() {
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        but.setTitle("提交", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(saveRegister), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
        
    }
    //MARK:网络请求
    func fetchRegisterList() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getCompanyRegister(planId: planId )) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                self.infoModel = RegisterModel(json: JSON(info)["resultObject"])
                self.tableView.reloadData()
                
            } else {
                
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
    }
    // MARK:tableVIew
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "PracticeRegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "PracticeRegisterTableViewCell")
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //AMRK:保存实习计划登记
    func saveRegister() {
        if startTime == "" {
            let vc = RemindViewController(title: "请选择起始时间", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        if endTime == "" {
            let vc = RemindViewController(title: "请选择结束时间", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        if company == "" {
            let vc = RemindViewController(title: "请填写实习单位", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        if address == "" {
            let vc = RemindViewController(title: "请选择所在地区", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        if detailAddress == "" {
            let vc = RemindViewController(title: "请填写详细地址", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        }
        let param:[String: AnyObject] = ["startTime":startTime as AnyObject,
                                         "endTime":endTime as AnyObject,
                                         "company": company as AnyObject,
                                         "area": address as AnyObject,
                                         "address": detailAddress as AnyObject]
        print(param)
        ServerProvider<ReportServer>().requestReturnDictionary(target: .companyRegister(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络错误", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                self.gointoNextStage()
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    // 改变当前的Stage
    func gointoNextStage() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .gotoNextStage(stage: "STAGE16_FEEDBACK")) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                let vc = SiteStatusFeedbackViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if alertView != nil {
            alertView.removeFromSuperview()
        }
    }
    
    
    
}
extension PracticeRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if canEdit {
            return 1
        }
        if self.infoModel == nil {
            return 0
        }
        //        if self.infoModel != nil && self.infoModel.auditRecordList.count == 0 {
        //            return 1
        //        }
        return  2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return firstArray.count
        default:
            return secondArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PracticeRegisterTableViewCell") as! PracticeRegisterTableViewCell
        if canEdit {
            cell.delegate = self
            cell.updateInfo(indexpath: indexPath, address: address, startTime: startTime, endTime: endTime)
        } else {
            cell.updateList(model: infoModel, indexpath: indexPath)
        }
        switch indexPath.section {
        case 0:
            cell.leftLabel.text = firstArray[indexPath.row]
        default:
            cell.leftLabel.text = secondArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        default:
            let titleLabel = UILabel()
            titleLabel.text = "    审核记录"
            titleLabel.backgroundColor = ZZMainLineGray
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            return titleLabel
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return 30
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if canEdit {
            let topString = firstArray[indexPath.row]
            switch topString {
            case "实习时间":
                if alertView != nil {
                    return
                } else {
                    alertView = ZZPickerView(pickerType: .Time, frame: CGRect(x: 0, y: ZZScreenHeight - 200, width: ZZScreenWidth, height: 200))
                    alertView.delegate = self
                    UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(alertView)
                }
            case "实习单位":
                break
            case "所在地区":
                if alertView != nil {
                    return
                } else {
                    alertView = ZZPickerView(pickerType: .Address, frame: CGRect(x: 0, y: ZZScreenHeight - 200, width: ZZScreenWidth, height: 200))
                    alertView.delegate = self
                    UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(alertView)
                }
            case "详细地址":
                break
            default:
                break
            }
            
        } else {
            
        }
        
    }
    
    
    
}


extension PracticeRegisterViewController: ZZPickerViewDelegate, RegisterCellDelegate {
    //MARK:取消
    func clickedCancle() {
        if alertView != nil {
            alertView.removeFromSuperview()
            alertView = nil
        }
    }
    
    //MARK:确定
    func clickedSure(selectedAddress: String) {
        print(selectedAddress)
        address = selectedAddress
        if alertView != nil {
            alertView.removeFromSuperview()
            alertView = nil
        }
        tableView.reloadData()
        
    }
    //AMRK:时间选择器的确定
    func dateDidSelecte(date: Date) {
        
        let stamp = ZZHelper.dateToTimeStamp(date: date)
        print("\(stamp)----------")
        if startTime != "" && endTime != "" {
            startTime = ""
            endTime = ""
        }
        if startTime == "" {
            startTime = "\(stamp)000"
            tableView.reloadData()
            
        } else if endTime == "" {
            endTime = "\(stamp)000"
            if startTime > endTime {
                let vc = RemindViewController(title: "请正确选择起始时间", type: .failure)
                self.present(vc, animated: true, completion: nil)
                startTime = ""
                endTime = ""
                tableView.reloadData()
            } else {
                tableView.reloadData()
            }
        }
        if alertView != nil {
            alertView.removeFromSuperview()
            alertView = nil
        }
        
        
    }
    
    
    //地址
    func getTextFieleContent(text: String, tag: Int) {
        if tag == 1 {
            company = text
            return
        }
        if tag == 3 {
            detailAddress = text
            return
        }
    }
}









