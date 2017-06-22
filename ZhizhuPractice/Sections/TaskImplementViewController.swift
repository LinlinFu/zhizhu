//
//  TaskImplementViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TaskImplementViewController: BaseViewController {

    var alertView: ZZAlertView!
    var planId = ""
    var tableView: UITableView!
    var dataSourceArray: [TaskApplyListModel] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ZZWhiteBackground
        fetchData()
    }

    
    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 70, y: 20, width: ZZScreenWidth - 140, height: 0), title: "温馨提示", detailTitle: "请在PC端进行实施填写与修改", type: .Simple)
        view.addSubview(alertView)
    }
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TaskApplyListCell", bundle: nil), forCellReuseIdentifier: "TaskApplyListCell")
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
        
        
    }
    

    
    //AMRK: 获取任务列表
    func fetchData() {
        let param: [String: AnyObject] = ["planId": planId as AnyObject,
                                          "status": 1 as AnyObject]
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getMissionDeclareList(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                for model in JSON(info)["resultObject"].arrayValue {
                    let data = TaskApplyListModel(json: model)
                    self.dataSourceArray.append(data)
                }
                if self.dataSourceArray.count == 0 {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   }


extension TaskImplementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskApplyListCell") as! TaskApplyListCell
        cell.updateImplementData(model: dataSourceArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = TaskDetailViewController()
        vc.type = .Implement
        vc.missionDeclareId = dataSourceArray[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}



