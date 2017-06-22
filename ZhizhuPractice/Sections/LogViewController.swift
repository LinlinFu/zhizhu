//
//  LogViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/24.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit


enum ControllerType {
    case Log // 日志
    case WeekReport // 周记
}

enum logStatus {
    case None // 没有数据
    case Hold // 有数据
}

class LogViewController: BaseViewController {

    var logStatus: logStatus = .Hold
    var tableView: UITableView!
    var type: ControllerType = .Log
    var alertView: ZZAlertView!
    var controllerText = ""
    var dataSourceArray: [LogWeekModel] = []
    //分页(10个数据分页)
    var offset: Int = 0
    // 是否加载
    var isFetching = false
    // 是否刷新
    var isRefreshing = false
    // 是否是当前计划
    var isCurrentPlan = true
    var planId = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .Log:
            controllerText = "日志"
            self.title = "实习\(controllerText)"
        case .WeekReport:
            controllerText = "周记"
            self.title = "实习\(controllerText)"
        }
        fetchData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildRightButton()
        
    }

    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 30, y: 20, width: ZZScreenWidth - 60, height: 0), title: "您还没有填写过\(controllerText)!", detailTitle: "点击右上方的”新建“,开始填写您的第一篇实习\(controllerText)吧!", type: .Complex)
        view.addSubview(alertView)
    }
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportTableViewCell")
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
        
        tableView.mj_header = ZZRefreshHeader(refreshingBlock: { 
            if self.isFetching {
                return
            }
            self.offset = 0
            self.isRefreshing = true
            self.fetchData()

        })
        tableView.mj_footer = ZZRefreshFooter(refreshingBlock: { 
            if self.isFetching {
                return
            }
            self.offset += 10
            self.fetchData()
            self.isRefreshing = false
        })
    }
    
    
    //MARK: 获取日志/周记记录
    func fetchData() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        if isFetching {
            return
        }

        var finalType: Int
        switch type {
        case .Log:
            finalType = 1
        case .WeekReport :
            finalType = 2
        }
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getStudentDailyReports(pageSize: 10, planId: planId, type: finalType, offset: offset)) { (success, info) in
            
            if self.isRefreshing {
                if self.tableView != nil {
                self.tableView.mj_header.endRefreshing()
                }
            } else {
                if self.tableView != nil {
                self.tableView.mj_footer.endRefreshing()
                }
            }
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                
                if self.offset == 0 {
                    self.dataSourceArray.removeAll()
                }
                for model in JSON(info)["resultObject"]["items"].arrayValue {
                    let data = LogWeekModel(json: model)
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
                
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func buildRightButton() {
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        but.setTitle("新建", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
        
    }
   
    //MARK: 新建
    func addAction() {
        let vc = LogAddViewController()
        vc.type = type
        vc.editType = .Add
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LogViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCell") as! ReportTableViewCell
        cell.updateLogData(model: dataSourceArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LogDetailViewController()
        vc.recordId = dataSourceArray[indexPath.row].id
        vc.title = "实习\(controllerText)" + "第\(dataSourceArray[indexPath.row].sort!)篇"
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
}

