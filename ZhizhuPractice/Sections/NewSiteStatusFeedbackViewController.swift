//
//  SiteStatusFeedbackViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

/// Identifier
private let materialCellId = "MaterialCellId"
private let expandMaterialCellId = "ExpandMaterialCellId"
private let newMterialCellId = "newMterialCellId"

class NewSiteStatusFeedbackViewController: BaseViewController {
    
    var tableView: UITableView!
    var alertView: ZZAlertView!
    var dataModel: FeekbackModel!
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
    // 新的数据源
    var personalProfile: SiteStatusProfile!
    // 数据变量
    var materialManager = MaterialManager(localDatas: NSMutableArray())
    var pageType: PlistType = .FeekbackMaterial
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "工地情况反馈"
        buildTableView()
    
        // 初始化数据
        if personalProfile == nil {
            fetchData()
        } else {
            loadFromPlist()
        }
    }
    
    
    // MARK: - 加载数据
    private func loadFromPlist() {
        let localDatas = PlistManger.queryPlistFile(plistType: pageType)
        materialManager = MaterialManager(localDatas: localDatas)
        materialManager.refreshMaterialForServer(personalProfile: personalProfile, type: pageType)
        tableView.reloadData()
    }
    
    
    func buildTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.allowsSelectionDuringEditing = true
        view.addSubview(tableView)
    }
    
    func buildHoldView() {
        alertView = ZZAlertView(frame: CGRect(x: 75, y: 40, width: ZZScreenWidth - 150, height: 100), title: "温馨提示", detailTitle: "请在PC端进行反馈填写", type: .Simple)
        view.addSubview(alertView)
    }
    
    //MARK: 网络请求
    func fetchData() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getWorksiteFeedback(planId: planId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                self.personalProfile = SiteStatusProfile(info: info as? [String : AnyObject])
                self.loadFromPlist()
//                if self.dataModel.id != "" {
//                    if self.tableView == nil {
//                        self.buildTableView()
//                    }
//                    self.tableView.reloadData()
//                    
//                } else {
//                    if self.alertView == nil {
//                        self.buildHoldView()
//                    }
//                }
                
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // 选择时间
    internal func selectDateForIndexPath(indexPath: NSIndexPath,
                                         content: String, superSection: Int?) {
        DatePickerDialog().show(content, doneButtonTitle: "确定",
                                cancelButtonTitle: "取消",
                                defaultDate: NSDate() as Date,
                                datePickerMode: .date) { (date) in
                                    if date == nil {
                                        return
                                    }
                                    let df = DateFormatter()
                                    df.dateFormat = "yyyy-MM-dd"
                                    let dateText = df.string(from: date! as Date)
                                    self.selectValue(value: dateText, preIndexPath: indexPath, superSection: superSection)
        }
    }

    
}
extension NewSiteStatusFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return materialManager.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materialManager.getNumberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 不可扩展加载Cell
        if !materialManager.isExpandType(section: indexPath.section) {
            var cell = tableView.dequeueReusableCell(withIdentifier: newMterialCellId) as?
            NewMaterialTableViewCell
            if cell == nil {
                cell = NewMaterialTableViewCell(style: .default, reuseIdentifier: newMterialCellId)
                cell?.delegate = self as? NewMaterialCellDelegate

            }
        if let item = materialManager.getAssignItem(indexPath: indexPath as NSIndexPath) {
            cell?.setCellData(data: item, indexPath: indexPath as NSIndexPath)
        }
          return cell!
        }
          return UITableViewCell()
    }
    
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        titleLabel.text = "    \(PrepareManager().getFeekbackTitleOfSection(section: section))"
        titleLabel.backgroundColor = ZZMainLineGray
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        return titleLabel
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if materialManager.isExpandType(section: indexPath.section) {
            return materialManager.expandCellHeight(indexPath: indexPath as NSIndexPath)
        }
        let item = materialManager.getAssignItem(indexPath: indexPath as NSIndexPath)
        guard let styleType = item?["StyleType"] as? Int else {
            return 0
        }
        switch styleType {
        case 4:
            return CGFloat(Int(ZZScreenWidth * 0.1))
        case 5:
            return CGFloat(Int(ZZScreenWidth * 0.5))
        default:
            return CGFloat(Int(ZZScreenWidth * 0.13))
        }

      }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 判断某项是否可以跳转
        guard let result = materialManager.isJumpForAssignItem(indexPath: indexPath as NSIndexPath) else {
            return
        }
        if result == 0 {
            let cell = tableView.cellForRow(at: indexPath) as? NewMaterialTableViewCell
            let content = cell?.leftLab.text
            MaterialJumpType.selectedSikpNewViewController(context: self, content: content,
                                                           indexPath: indexPath as NSIndexPath, superSection: nil)
        }

    }
    
}

extension NewSiteStatusFeedbackViewController: NewMaterialCellDelegate {
    func materialValueChange(value: String, indexPath: NSIndexPath, isParse: Bool) {
        let serverKey = materialManager
            .setAssginItemValue(value: value, indexPath: indexPath, superSection: nil)
        if isParse == true {
            let intValue = SiteStatusProfile.parsePropertValue(text: value)
            personalProfile.setValue(intValue, forKey: serverKey!)
        } else {
            personalProfile.setValue(value, forKey: serverKey!)
        }
    }
}


extension NewSiteStatusFeedbackViewController: MaterialChoiceDelegate {
    
    // 选中某个结果触发事件
    func selectValue(value: String, preIndexPath: NSIndexPath, superSection: Int?) {
        if superSection == nil {
            let cell = tableView.cellForRow(at: preIndexPath as IndexPath) as? NewMaterialTableViewCell
            cell?.setCellRightLabValue(value: value)
            let serverKey = materialManager.setAssginItemValue(value: value, indexPath: preIndexPath, superSection: nil)
            // 当更改籍贯数据时
            if serverKey == nil {
                personalProfile.setValue(value, forKey: "nativeProvince_nativeCity")
            } else if serverKey == "married" {
                let intValue = SiteStatusProfile.parsePropertValue(text: value)
                personalProfile.setValue(intValue, forKey: serverKey!)
            } else {
                personalProfile.setValue(value, forKey: serverKey!)
            }
        } else {
            
        }
    }
    // 子cell中选中某项
//    func subcellSelected(superSection: Int, indexPath: NSIndexPath, content: String?) {
//        MaterialJumpType.selectedSikpNewViewController(self, content: content,
//                                                       indexPath: indexPath,
//                                                       superSection: superSection)
//    }
//    func expandValueChange(value: String, indexPath: NSIndexPath, superSection: Int) {
//        let serverKey = materialManager
//            .setAssginItemValue(value, indexPath: indexPath, superSection: superSection)
//        personalProfile.setValueForExpandKey(serverKey, value: value, section: indexPath.section, page: pageType)
//    }
}
