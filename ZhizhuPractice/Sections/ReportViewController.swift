//
//  ReportViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {

    //
    var tableView: UITableView!
    //数据
    var dataModel: AllPracticeStatusModel!
    // timeModel
    var timeModel: AllExercitationTimesModel!
    var alertView: ZZAlertView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTimePeriod()
        getLogWeekCount()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 80, y: 20, width: ZZScreenWidth - 160, height: 0), title: "温馨提示", detailTitle: "您没有正在进行的实习", type: .Simple)
        view.addSubview(alertView)
    }

    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.backgroundColor = ZZWhiteBackground
        tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        view.addSubview(tableView)
    }
    
    //MARK: 获取日志周记已完成数
    func getLogWeekCount() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getExercitationGoingInfos) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                self.dataModel = AllPracticeStatusModel(json: JSON(info)["resultObject"])
                if self.tableView == nil {
                    self.buildTableView()
                } else {
                    self.tableView.reloadData()
                }
            } else {
                if JSON(info)["errorMessage"].stringValue == "您没有正在进行的实习" {
                    if self.alertView == nil {
                        self.buildNoneLogUI()
                        return
                    }
                }
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue , type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: 获取中期汇报/实习总结时间段
    func getTimePeriod() {
        
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getExercitationGoingTimes) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                self.timeModel = AllExercitationTimesModel(json: JSON(info)["resultObject"])
                if self.tableView == nil {
                    self.buildTableView()
                } else {
                    self.tableView.reloadData()
                }
            } else {
                if JSON(info)["errorMessage"].stringValue == "您没有正在进行的实习" {
                    return
                }
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue , type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataModel != nil && self.timeModel != nil ? 5 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell") as! ReportTableViewCell
        let topString: String = ReportManager().getRowArray(section: indexPath.section)[indexPath.row]
        cell.updateCellData(dayModel: dataModel, timeModel: timeModel, topString: topString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topString: String = ReportManager().getRowArray(section: indexPath.section)[indexPath.row]
        switch topString {
        case "实习任务":
            let vc = TaskViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "实习日志":
            let vc = LogViewController()
            vc.type = .Log
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "实习周记":
            let vc = LogViewController()
            vc.type = .WeekReport
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "中期汇报":
            if self.timeModel.report.status == 1 {
                 return
            }
            let vc = MidPeriodViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "实习总结":
            if self.timeModel.summary.status == 1 {
                return
            }
            let vc = PracticeSummaryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            return
        }
    }
}
