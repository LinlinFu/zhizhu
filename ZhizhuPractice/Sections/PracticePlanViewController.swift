//
//  PracticePlanViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class PracticePlanViewController: BaseViewController {
    
    var tableView: UITableView!
    var alertView: ZZAlertView!
    var dataArray: [PlanListModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实习计划"
    }
    
    
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZZWhiteBackground
        tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func buildHoldView() {
        alertView = ZZAlertView(frame: CGRect(x: 75, y: 40, width: ZZScreenWidth - 150, height: 100), title: "温馨提示", detailTitle: "暂无实习计划", type: .Simple)
        view.addSubview(alertView)
    }
    
    func fetchData() {
            ServerProvider<ReportServer>().requestReturnDictionary(target: .getPlanListByUserId) { (success, info) in
                guard let info = info else {
                    let vc = RemindViewController(title: "网络异常", type: .failure)
                    self.present(vc, animated: true, completion: nil)
                    return
                }
                
                if success && JSON(info)["status"].intValue == 200 {
                    self.dataArray.removeAll()
                    for model in JSON(info)["resultObject"].arrayValue {
                        let data = PlanListModel(json: model)
                        self.dataArray.append(data)
                    }
                    if self.dataArray.count == 0 {
                        if self.alertView == nil {
                        self.buildHoldView()
                        }
                    } else {
                        if self.tableView == nil {
                        self.buildTableView()
                        }
                        self.tableView.reloadData()
                    }
                    
                }
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
extension PracticePlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
        cell.updatePlanData(model: dataArray[indexPath.row])
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = PlanDetailViewConroller()
        vc.title = dataArray[indexPath.row].planName
        vc.planId = dataArray[indexPath.row].exercitationPlanId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

