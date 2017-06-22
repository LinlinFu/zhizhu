//
//  PraticeReportViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/25.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit





class PraticeReportViewController: BaseViewController {

    var tableView: UITableView!
    var alertView: ZZAlertView!
    var dataModel: ReportModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "实习报道"
    }
    

    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ZZWhiteBackground
        tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ContentTableViewCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    func buildHoldView() {
        alertView = ZZAlertView(frame: CGRect(x: 75, y: 40, width: ZZScreenWidth - 150, height: 100), title: "温馨提示", detailTitle: "请在PC端进行实习报道填写", type: .Simple)
        view.addSubview(alertView)
    }

    func fetchData() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCompanyReport(planId: AppKeys.getPlanId())) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            
            if success && JSON(info)["status"].intValue == 200 {
                self.dataModel = ReportModel(json:JSON(info)["resultObject"])

                if self.dataModel.reportTime != "" {
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
extension PraticeReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.dataModel != nil ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrepareManager().getReportRowArray(section: section).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topString = PrepareManager().getReportRowArray(section:indexPath.section)[indexPath.row]
        if indexPath.row > 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell") as! ContentTableViewCell
            cell.updateReportData(topString: topString, model: dataModel, row: indexPath.row)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
        cell.updateReportData(topString: topString, model: dataModel, indexpath: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        default:
            let titleLabel = UILabel()
            titleLabel.text = "    审核记录"
            titleLabel.backgroundColor = ZZMainLineGray
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            return titleLabel
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0.1
        default:
            return 30
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 1 {
             let topString = PrepareManager().getReportRowArray(section:indexPath.section)[indexPath.row]
            switch topString {
            case "工作内容":
                return 60 + UILabel.heightForLabel(text: dataModel.workingContent as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 40)
            case "公司规定":
                return 60 + UILabel.heightForLabel(text: dataModel.companyRules as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 40)
            case "疑难救助":
                return 60 + UILabel.heightForLabel(text: dataModel.workingHelp as NSString?, font: UIFont.systemFont(ofSize: 14), width: ZZScreenWidth - 40)
            default:
                return 0
            }
        }
        return 50
    }
}

