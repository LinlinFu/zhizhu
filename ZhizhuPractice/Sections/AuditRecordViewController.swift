//
//  AuditRecordViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AuditRecordViewController: BaseViewController {

    
    var missionDeclareId = ""
    var dataArray: [NewAuditRecordList] = []
    var alertView: ZZAlertView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "审核记录"
        fetchData()
        
    }
    


    //AMRK: 获取任务列表
    func fetchData() {
        
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getAuditRecordList(missionDeclareId: missionDeclareId)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                
                for model in JSON(info)["resultObject"].arrayValue {
                    let data = NewAuditRecordList(json: model)
                    self.dataArray.append(data)
                }
                if self.dataArray.count == 0 {
                    if self.alertView == nil {
                        self.buildNoneLogUI()
                    }
                } else {
                    if self.tableView == nil {
                        self.buildTableView()
                    }
                    self.tableView.reloadData()
                }
                
                
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }

    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
        
        
    }

    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 100, y: 20, width: ZZScreenWidth - 200, height: 0), title: "温馨提示", detailTitle: "暂无审核记录", type: .Simple)
        view.addSubview(alertView)
    }
  
}

extension AuditRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "recordCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "recordCell")
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "审核结果"
            switch dataArray[indexPath.section].status ?? 0 {
            case 0:
                cell?.detailTextLabel?.text = "未审核"
                cell?.detailTextLabel?.textColor = ZZOrangeText
            case 1:
                cell?.detailTextLabel?.text = "审核通过"
                cell?.detailTextLabel?.textColor = ZZDarkGreenText
            case -2:
                cell?.detailTextLabel?.text = "审核不通过"
                cell?.detailTextLabel?.textColor = ZZOrangeText
            default:
                break
            }
        default:
            cell?.textLabel?.text = "审核时间"
            cell?.detailTextLabel?.text = ZZHelper.timeFormat(timeStamp: dataArray[indexPath.section].auditTime!, format: "yyyy/MM/dd")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth - 10, height: 30))
        label.text = "    \(dataArray[section].comment ?? "")"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
        
    }
    
    
}


