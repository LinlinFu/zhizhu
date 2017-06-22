//
//  MidPeriodViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/7.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class MidPeriodViewController: BaseViewController {

    var alertView: ZZAlertView!
    var planId = ""
    var isCurrentPlan = true
    var tableView: UITableView!
    var headerArray = ["汇报内容", "教师点评"]
    var dataModel: PracticeSummaryModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "中期汇报"
        getMiddleReport()
        
    }

    func buildNoneLogUI() {
        var final = "没有查到您的汇报信息"
        if isCurrentPlan {
            final = "请在PC端填写提交"
        }
        alertView = ZZAlertView(frame: CGRect(x: 80, y: 20, width: ZZScreenWidth - 160, height: 0), title: "温馨提示", detailTitle: final, type: .Simple)
        view.addSubview(alertView)
    }
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        if isCurrentPlan {
            tableView.tableHeaderView = RemiandHeaderView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 40))
        }
        tableView.backgroundColor = ZZWhiteBackground
        tableView.register(UINib(nibName: "FileSingleTableViewCell", bundle: nil), forCellReuseIdentifier: "FileSingleTableViewCell")
        view.addSubview(tableView)
    }
    
    //headerView
    

    
    //MARK: 查询中期汇报内容
    func getMiddleReport() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getSummaryByPlanIdAndType(type: 1, planId: planId)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && (JSON(info)["status"].stringValue == "200") {
                self.dataModel = PracticeSummaryModel(json: JSON(info)["resultObject"])
                if self.dataModel.summary.id != "" {
                    if self.tableView == nil {
                        self.buildTableView()
                    }
                    self.tableView.reloadData()
                } else {
                    if self.alertView == nil {
                        self.buildNoneLogUI()
                    }
                }
                
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}

extension MidPeriodViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel != nil ? headerArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                var cell = tableView.dequeueReusableCell(withIdentifier: "BaseTextTableViewCell") as? BaseTextTableViewCell
                if cell == nil {
                    cell = BaseTextTableViewCell(style: .default, reuseIdentifier: "BaseTextTableViewCell")
                }
                cell?.contentLabel.text = dataModel.summary.descript
                return cell!
            case 1:
                let cell: FileSingleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FileSingleTableViewCell") as! FileSingleTableViewCell
                cell.dataArray = dataModel.fileList
                return cell
            default:
                return UITableViewCell()
            }
        case 1:
            switch indexPath.row {
            case 0:
                var cell = tableView.dequeueReusableCell(withIdentifier: "scorecell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "scorecell")
                }
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.textLabel?.text = "评分:  \(dataModel.summary.score!)"
                cell?.selectionStyle = .none
                return cell!
            case 1:
                var cell = tableView.dequeueReusableCell(withIdentifier: "BaseTextTableViewCell") as? BaseTextTableViewCell
                if cell == nil {
                    cell = BaseTextTableViewCell(style: .default, reuseIdentifier: "BaseTextTableViewCell")
                }
                
                cell?.contentLabel.text = dataModel.summary.remarks
                return cell!
  
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        titleLabel.text = "    \(headerArray[section])"
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
        CGFloat {
            
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return 30 + UILabel.heightForLabel(text: dataModel.summary.descript as NSString, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 30)
                case 1:
                    let zhengCount: Int = dataModel.fileList.count / 5
                    let yuCount: Int = dataModel.fileList.count % 5
                    if yuCount == 0 {
                        return CGFloat(zhengCount * 60 + (zhengCount - 1) * 10 + 40)
                    }
                    let a = zhengCount * 60 + 60
                    let b = (zhengCount - 1) * 10
                    return CGFloat(a + 40 + b)
                default:
                    return 0
                }
            case 1:
                switch indexPath.row {
                case 0:
                    return 50
                case 1:
                   return 30 + UILabel.heightForLabel(text: dataModel.summary.remarks as NSString, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 30)
                default:
                    return 0
                }
            default:
                return 0
            }
    }
    
}



