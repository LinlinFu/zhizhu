//
//  SettingViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/18.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    // 列表
    var tableView: UITableView!
    var cellTitleArray = ["新通知提醒", "允许非Wi-Fi网络下载/上传", "当前版本", "关于我们"]
    var logoutButton: UIButton!
    var checkEnvironment: UILabel!
    // 上次点击时间
    var lastClickTime = NSDate()
    // 点击次数
    var clickTimes: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if logoutButton != nil && checkEnvironment != nil {
        logoutButton.removeFromSuperview()
        checkEnvironment.removeFromSuperview()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        buildTableView()
        
    }
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = ZZWhiteBackground
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
        view.addSubview(tableView)
    }

    func setupUI() {
        logoutButton = UIButton()
        checkEnvironment = UILabel()
        [logoutButton, checkEnvironment].forEach { (subview) in
            UIApplication.shared.keyWindow?.addSubview(subview)
        }
        layoutSubview()
        logoutButton.setTitle("退出账号", for: .normal)
        logoutButton.backgroundColor = ZZMainGreen
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        
        checkEnvironment.textAlignment = .center
        checkEnvironment.isUserInteractionEnabled = true
        checkEnvironment.font = UIFont.systemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self, action: #selector(checkEnvironmentAction(tap:)))
        checkEnvironment.addGestureRecognizer(tap)
        let isDev = ZZHelper.isDevEvironment()
        if isDev {
            checkEnvironment.text = "测试环境"
            checkEnvironment.textColor = ZZGray
            
        } else {
//            checkEnvironment.text = "正式环境"
//            checkEnvironment.textColor = ZZWhiteBackground
        }

        
        
    }
    
    func layoutSubview() {
        logoutButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        
        checkEnvironment.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.bottom.equalTo(logoutButton.snp.top).offset(-20)
        }

    }
        
    //MARK: 退出账号
    func logoutAction() {
        let alertVC = UIAlertController(title: "提示", message: "是否确认退出账号", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default, handler: { ( action
            ) in
            ZZHelper.clearUserData()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        alertVC.addAction(sureAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    //MARK: 切换服务器 判断连击次数是否达到十次
    func checkEnvironmentAction(tap: UITapGestureRecognizer) {
        let currentTime = NSDate()
        let interval = currentTime.timeIntervalSince(lastClickTime as Date)
        if interval < 1 {
            clickTimes += 1
        } else {
            clickTimes = 0
        }
        if clickTimes == 10 {
            
            let isDev = !ZZHelper.isDevEvironment()
            UserDefaults.standard.set(isDev, forKey: AppKeys.isDev)
            let message = isDev ? "切换为测试环境" : "切换为正式环境"
            let vc = RemindViewController(title: message, type: .success)
            self.present(vc, animated: true, completion: {
                self.clickTimes = 0
            })
            ZZHelper.clearUserData()
            
        }
        
        lastClickTime = currentTime

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 1 {
            let cell: SwitchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as! SwitchTableViewCell
            cell.updateDate(row: indexPath.row, titleArray: cellTitleArray)
            return cell
        }
        var cell =  tableView.dequeueReusableCell(withIdentifier: "setCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "setCell")
        }
        cell?.textLabel?.text = cellTitleArray[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell?.accessoryType = .disclosureIndicator
        if cellTitleArray[indexPath.row] == "关于我们" {
            cell?.selectionStyle = .default
        } else {
            cell?.selectionStyle = .none
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
        switch cellTitleArray[indexPath.row] {

        case "关于我们":
            let vc = AboutUsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            return
        }
    }
}
