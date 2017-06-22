//
//  MineViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {

    // 
    var tableView: UITableView!
    var cellTitleArray = ["实习计划", "考核汇总", "个人资料", "账户安全", "设置"]
    
    var albumManager: AlbumManager!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tableView != nil {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumManager = AlbumManager(context: self)
        buildTableView()
        
    }
    
    
    
    
    
    func buildTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = ZZWhiteBackground
        let header = MineTableViewHeader(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 200))
        tableView.tableHeaderView = header
        view.addSubview(tableView)
        
        // 修改头像
        header.tapAvatarHandle = { [weak self] (imageView) in
            print(123)
            guard let sSelf = self else { return }
            
            sSelf.albumManager.startAlbumAction(isCamera: false) { (resultImage) in
                guard let image = resultImage else {
                    return
                }
                let data: Data = UIImagePNGRepresentation(image)!
                let imageName = String(describing: NSDate()) + ".jpg"
                print(data)
                let param = ["name":imageName,"refRelationCategory":"USER_PHOTO_LOCATION_CUT"]
              ServerProvider<AccountServer>().upLoadImageRequest(urlString: "\(ZZHelper().uploadURL)/file/phoneUpload", params: param, data: data, fileName: imageName, success: { (response) in
                let photoUrl = JSON(response)["resultObject"]["filePath"].stringValue
                ServerProvider<AccountServer>().requestReturnDictionary(target: .getUserPhoto(photoUrl: JSON(response)["resultObject"]["filePath"].stringValue), completion: { (success, info) in
                    guard let info = info else {
                        let vc = RemindViewController(title: "网络异常", type: .failure)
                        self?.present(vc, animated: true, completion: nil)
                        return }
                    if success && JSON(info)["status"].stringValue == "200" {
                        imageView.image = resultImage
                        UserDefaults.standard.set(photoUrl, forKey: AppKeys.UserphotoUrl)
                    } else {
                        let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                        self?.present(vc, animated: true, completion: nil)
                    }
                })
                
              }, failture: { (error) in
                print("\(error)---------")
                
              })
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell =  tableView.dequeueReusableCell(withIdentifier: "mineCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "mineCell")
        }
        cell?.textLabel?.text = cellTitleArray[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cellTitleArray[indexPath.row] {
        case "实习计划":
            let vc = PracticePlanViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "考核汇总":
            let vc = CheckGradesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "个人资料":
            let vc = RemindViewController(title: "该功能暂未开放", type: .failure)
            self.present(vc, animated: true, completion: nil)
            return
        case "账户安全":
            let vc = AccountSaftyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        case "设置":
            let vc = SettingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            return
        default:
            return
        }
    }
}
