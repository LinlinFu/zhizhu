//
//  SiteStatusFeedbackViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit



class SiteStatusFeedbackViewController: BaseViewController {
        
    var tableView: UITableView!
    var alertView: ZZAlertView!
    var dataModel: FeekbackModel!
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchData()
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "工地情况反馈"
        }
        
        
        
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZZWhiteBackground
        tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
        tableView.separatorStyle = .none
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
                self.dataModel = FeekbackModel(json:JSON(info)["resultObject"])
                
                if self.dataModel.id != "" {
                    if self.tableView == nil {
                        self.buildTableView()
                    }
                    self.tableView.reloadData()
                    
                } else {
                    if self.alertView == nil {
                        self.buildHoldView()
                    }
                }
                
            }
            
        }
    }

        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
        
        
        
    }
extension SiteStatusFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return self.dataModel != nil ? 6 : 0
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return PrepareManager().getFeekbackRowArray(section: section).count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let topString = PrepareManager().getFeekbackRowArray(section: indexPath.section)[indexPath.row]
            if indexPath.section == 4 || (indexPath.section == 5 && indexPath.row == 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell
                cell.updateFeekbackData(topString: topString, model: dataModel, indexpath: indexPath)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
            cell.updateFeekbackData(topString: topString, model: dataModel, indexpath: indexPath)
            
            return cell
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
            switch indexPath.section {
            case 4:
                return 40 + UILabel.heightForLabel(text: dataModel.descript as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 40)
            case 5:
                if indexPath.row == 2 {
                   return 40 + UILabel.heightForLabel(text: dataModel.auditRecordList.first?.comment as NSString? ?? "" as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 40)
                }
            default:
                return 50
            }
            return 50
        }
}

