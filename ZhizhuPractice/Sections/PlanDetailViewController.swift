//
//  PlanDetailViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class PlanDetailViewConroller: BaseViewController {
    
    var tableView: UITableView!
    var alertView: ZZAlertView!
    var planId = ""
    //岗前准备
    var preModel: PlanTimeModel!
    // 实习进行
    var conductModel: PlanTimeModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTableView()
        fetchPreDate()
        fetchConductDate()
    }
    
    //MARK: 获取岗前准备和实习进行时间
    func fetchPreDate() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getProcedureTimeByParam(type: "PRE_TIME", planId: planId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].stringValue
            if success && status == "200" {
                self.preModel = PlanTimeModel(json: JSON(info)["resultObject"])
                self.tableView.reloadData()
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }

        }
    }
    
    func fetchConductDate() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getProcedureTimeByParam(type: "CONDUCT_TIME", planId: planId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].stringValue
            if success && status == "200" {
                self.conductModel = PlanTimeModel(json: JSON(info)["resultObject"])
                self.tableView.reloadData()
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }

    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
extension PlanDetailViewConroller: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.preModel == nil || self.conductModel == nil) ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrepareManager().getPlanRowArray(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topString = PrepareManager().getPlanRowArray(section: indexPath.section)[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "planCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "planCell")
        }
        cell?.textLabel?.text = topString
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let titleLabel = UILabel()
        switch section {
        case 0:
            titleLabel.text = "    岗前准备" + "\(ZZHelper.timeFormat(timeStamp: preModel.startTime, format: "yyyy/MM/dd"))-\(ZZHelper.timeFormat(timeStamp: preModel.endTime, format: "yyyy/MM/dd"))"
        case 1:
            titleLabel.text = "    实习进行" + "\(ZZHelper.timeFormat(timeStamp: conductModel.startTime, format: "yyyy/MM/dd"))-\(ZZHelper.timeFormat(timeStamp: conductModel.endTime, format: "yyyy/MM/dd"))"
        default:
            titleLabel.text = "    实习考核"
        }
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
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topString = PrepareManager().getPlanRowArray(section: indexPath.section)[indexPath.row]
        switch topString {
        case "实习动员":
            let vc = PrepareDetailViewController()
            vc.pageType = .MOBILIZE
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "安全教育":
            let vc = PrepareDetailViewController()
            vc.pageType = .EDUCATION
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "实习承诺":
            let vc = PrepareDetailViewController()
            vc.pageType = .COMMITMENT
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "实习计划登记":
            let vc = PracticeRegisterViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
            return
//        case "实习报道":
//            let vc = PraticeReportViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
        case "工地情况反馈":
            let vc = TestFeedbackViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "实习签到":
            let vc = SignViewController()
            vc.title = "实习签到"
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "实习日志":
            let vc = LogViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            vc.type = .Log
            self.navigationController?.pushViewController(vc, animated: true)
        case "实习周记":
            let vc = LogViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            vc.type = .WeekReport
            self.navigationController?.pushViewController(vc, animated: true)
        case "实习任务":
            let vc = TaskViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
        case "中期汇报":
            let vc = MidPeriodViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "实习总结":
            let vc = PracticeSummaryViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "查看成绩":
            let vc = CheckGradesViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "上传附件":
            let vc = UploadFilesViewController()
            vc.planId = planId
            vc.isCurrentPlan = false
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            return
        }
    }
}


