//
//  LogDetailViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit


class LogDetailViewController: BaseViewController {

    
    var tableView: UITableView!
    var recordId: String = ""
    var model: LogWeekDetailModel!
    var statusArray: [RecentStatusModel] = []
    var titleArray: [String] = []
    var type: ControllerType = .Log

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLodWeekDetail()
        getRecentStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case .Log:
            titleArray = ["项目进展情况", "本人参与工程实践情况", "设计规范标准"]
        case .WeekReport:
            titleArray = ["本周实践工作简述", "本周所学工作要点"]
        }
        
        buildTableView()
        
        
    }
    
    func buildRightItem() {
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        but.setTitle("修改", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(modifyAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
    }
    
    //MARK: 修改
    func modifyAction() {
        let vc = LogAddViewController()
        vc.type = type
        vc.editType = .Modify
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "LogDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "LogDetailTableViewCell")
        tableView.register(UINib(nibName: "TeacherRemarkTableViewCell", bundle: nil), forCellReuseIdentifier: "TeacherRemarkTableViewCell")
        tableView.register(UINib(nibName: "RecentNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentNewsTableViewCell")
        tableView.register(UINib(nibName: "LogPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "LogPhotoTableViewCell")
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
    }
    
    //MARK:获取周日报详情
    func fetchLodWeekDetail() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getStudentDailyReportDetail(id: recordId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                self.model = LogWeekDetailModel(json: JSON(info)["resultObject"]["report"])
                if self.model.remarks == "" {
                    self.buildRightItem()
                }
                if self.tableView != nil {
                    self.tableView.reloadData()
                } else {
                    self.buildTableView()
                }
            }
            
        }
    }
    
    //MARK:获取学生最新动态
    func getRecentStatus() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getUserLogsList(size: 10)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                for data in JSON(info)["resultObject"].arrayValue {
                    let result = RecentStatusModel(json: data)
                    self.statusArray.append(result)
                }
                if self.tableView != nil {
                    self.tableView.reloadData()
                } else {
                    self.buildTableView()
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }


}
extension LogDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.model == nil {
            return 0
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return titleArray.count
        case 3:
            return statusArray.count > 5 ? 5 : statusArray.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let topString = titleArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogDetailTableViewCell") as! LogDetailTableViewCell
            cell.updateLogDetailData(topString: topString, model: model, row: indexPath.row)
        return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogPhotoTableViewCell") as! LogPhotoTableViewCell
            cell.dataArray = model.fileList
            cell.canEdit = false
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherRemarkTableViewCell") as! TeacherRemarkTableViewCell
            cell.updateRemark(model: model)
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentNewsTableViewCell") as! RecentNewsTableViewCell
            cell.updateRecentData(model: statusArray[indexPath.row])
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 30
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let headerView = UIView()
            let line1 = UIView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 1))
            let label = UILabel(frame: CGRect(x: 15, y: 1, width: 100, height: 28))
            let line2 = UIView(frame: CGRect(x: 0, y: 29, width: ZZScreenWidth, height: 1))
            [line1, line2].forEach({ (line) in
                line.backgroundColor = ZZMainLineGray
                headerView.addSubview(line)
            })
            headerView.addSubview(label)
            label.text = "最新动态"
            label.font = UIFont.systemFont(ofSize: 14)
            return headerView
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if model.descript == "" {
                    return 60
                }
                return 60 + UILabel.heightForLabel(text: model.descript as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 30)
            case 1:
                if model.practice == "" {
                    return 60
                }
                return 60 + UILabel.heightForLabel(text: model.practice as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 30)
            case 2:
                if model.standards == "" {
                    return 60
                }
                return 60 + UILabel.heightForLabel(text: model.standards as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 30)
                
            default:
                return 0
            }
        case 1:
            let width = (ZZScreenWidth - 70) / 5.0
            let zhengCount: Int = model.fileList.count / 5
            let yuCount: Int = model.fileList.count % 5
            if yuCount == 0 {
                let firstResult: CGFloat = CGFloat(zhengCount) * width
                return firstResult + CGFloat(zhengCount - 1) * 10.0 + 40.0
            }
            let a: CGFloat = CGFloat(zhengCount) * width + width
            let b: CGFloat = CGFloat(zhengCount - 1) * 10.0
            return a + 40 + b
        case 2:
            if model.remarks == "" {
                return 80
            }
            return 100 + UILabel.heightForLabel(text: model.remarks as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 30)
        default:
            return 60
        }
      }
    
       
}




