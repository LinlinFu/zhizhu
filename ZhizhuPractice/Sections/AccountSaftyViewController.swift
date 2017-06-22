//
//  AccountSaftyViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/26.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AccountSaftyViewController: BaseViewController {

    
    var cellTitleArray = ["登录密码", "手机号码"]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账户安全"
        buildTableView()
        
    }
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = ZZWhiteBackground
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
extension AccountSaftyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "mineCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "mineCell")
        }
        cell?.textLabel?.text = cellTitleArray[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.row == 0 {
            cell?.detailTextLabel?.text = "修改"
        } else {
            let tel = AppKeys.getUserTel()
            let newTel = (tel as NSString).replacingCharacters(in: NSRange(location: 3, length: 4), with: "****")
            cell?.detailTextLabel?.text = newTel
        }
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = ModifyPasswordViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case 1:
            let vc = ForgetPasswordViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            return
        }
    }
}
