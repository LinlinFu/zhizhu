//
//  CheckGradesViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/31.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class CheckGradesViewController: BaseViewController {

    var tableView: UITableView!
    var headerView: UIView!
    var planId: String!
    var scoreModel: GradesModel!
    var isCurrentPlan = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDate()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "考核成绩"
        buildHeaderView()
        buildTableView()
        
    }
    
    func buildHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 200))
        let imageView = UIImageView()
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(150)
            make.center.equalTo(headerView.snp.center)
        }
        imageView.backgroundColor = UIColor.orange
        imageView.layer.cornerRadius = 75
        let score = UILabel()
        score.text = "最终得分"
        score.textColor = ZZWhiteBackground
        score.font = UIFont.systemFont(ofSize: 14)
        headerView.addSubview(score)
        score.snp.makeConstraints { (make) in
            make.center.equalTo(headerView.snp.center)
        }
        
    }
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
    }
    
    //MARK: 查询考核成绩
    func fetchDate() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getExamingScores(planId: planId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].stringValue
            if success && status == "200" {
                self.scoreModel = GradesModel(json: JSON(info)["resultObject"])
                self.tableView.reloadData()
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
extension CheckGradesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrepareManager().getGradesRowArray(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topString = PrepareManager().getGradesRowArray(section: indexPath.section)[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "planCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "planCell")
        }
        cell?.selectionStyle = .none
        cell?.detailTextLabel?.textColor = ZZRed
        cell?.textLabel?.text = topString
        switch topString {
        case "签到得分":
            cell?.detailTextLabel?.text = String(scoreModel.attendScore)
        case "日志得分":
            cell?.detailTextLabel?.text = String(scoreModel.dayScore)
        case "周记得分":
            cell?.detailTextLabel?.text = String(scoreModel.weekScore)
        case "任务得分":
            cell?.detailTextLabel?.text = String(scoreModel.missionScore)
        case "中期得分":
            cell?.detailTextLabel?.text = String(scoreModel.midScore)
        case "总结得分":
            cell?.detailTextLabel?.text = String(scoreModel.finalScore)
        default:
            break
        }
        return cell!
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
    }



}
