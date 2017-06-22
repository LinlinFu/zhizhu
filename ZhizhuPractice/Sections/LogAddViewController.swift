//
//  LogAddViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/1.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

enum EditType {
    case Add //新增
    case Modify //修改
}

class LogAddViewController: BaseViewController {
        
        
    var tableView: UITableView!
    var recordId: String = ""
    var model: LogWeekDetailModel!
    var statusArray: [RecentStatusModel] = []
    var editType: EditType = .Add
    var type: ControllerType = .Log
    var albumManager: AlbumManager!
    // 上传图片数组
    var uploadPhotoArray: [JSON] = []
    // 新键图片数组
    var addPhotoArray: [FileListModel] = []
    var descript = ""
    var practice = ""
    var standards = ""
    // 是否是第一次获取cell中textView的题
    var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumManager = AlbumManager(context: self)
        switch editType {
        case .Add:
            self.title = "新增周记"
            
        case .Modify:
            self.title = "修改周记"
            descript = model.descript
            practice = model.practice
            standards = model.standards

        }
        
        
        buildRightItem()
        buildTableView()
        getRecentStatus()
            
    }
    
        
    func buildRightItem() {
        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        but.setTitle("提交", for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        but.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
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
                }
                
            }
            
        }
    }

    
    // MARK: 配置参数
    func configParams() -> (Int, String){
        print("\(descript)+++++++++")
        print("\(practice)----------")
        print("\(standards)========")
        var typeInt = 0
        switch type {
        case .Log:
            typeInt = 1
        case .WeekReport:
            typeInt = 2
        }
        var idString = ""
        switch editType {
        case .Add:
            idString = ""
        case .Modify:
            idString = model.id
        }

        return (typeInt,idString)
    }
    //MARK: 提交
    func submitAction() {
        
        let typeInt = configParams().0
        let idString = configParams().1
        let param: [String: AnyObject] = ["exercitationPlanId":AppKeys.getPlanId() as AnyObject,
                                          "type": typeInt as AnyObject,
                                          "id": idString as AnyObject,
                                          "description":descript as AnyObject,
                                          "practice": practice as AnyObject,
                                          "standards":standards as AnyObject,
                                          "files": "\(uploadPhotoArray)" as AnyObject]
        ServerProvider<ReportServer>().requestReturnDictionary(target: .saveDailyReportDetail(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
                
            if success && JSON(info)["status"].intValue == 200 {
                let vc = RemindViewController(title: "提交成功", type: .success)
                self.present(vc, animated: true, completion: nil)
                self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
                
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
            }
                
        }
    }
    
    //MARK: tableViewDelegate, tableViewDatasouce
        func buildTableView() {
            tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64), style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "LogAddTableViewCell", bundle: nil), forCellReuseIdentifier: "LogAddTableViewCell")
            tableView.register(UINib(nibName: "RecentNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentNewsTableViewCell")
            tableView.register(UINib(nibName: "LogPhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "LogPhotoTableViewCell")
            tableView.backgroundColor = ZZWhiteBackground
            view.addSubview(tableView)
        }
        
        
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            
        }
        
        
    }
extension LogAddViewController: UITableViewDelegate, UITableViewDataSource, AddCellDelegate {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch section {
            case 0:
                return type == .Log ? 3 : 2
            case 1:
                return 1
            case 2:
                return statusArray.count > 5 ? 5 : statusArray.count
            default:
                return 0
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LogAddTableViewCell") as! LogAddTableViewCell
                cell.delegate = self
                switch editType {
                case .Add:
                    cell.updateLogAddData(data: ReportManager().getLogAddRow(type: type, row: indexPath.row))
                case .Modify:
                    cell.modifyData(topString: ReportManager().getLogAddRow(type: type, row: indexPath.row).topString, model: model, row: indexPath.row, descript: descript, practice: practice, standards: standards)
                    
                }
                
                return cell
            }
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LogPhotoTableViewCell") as! LogPhotoTableViewCell
                switch editType {
                case .Add:
                    cell.dataArray = addPhotoArray
                case .Modify:
                    cell.dataArray = model.fileList
                }
                cell.canEdit = true
                // 删除
                cell.deleteBolck = {(row)-> Void in
                    print("--------------")
                    print(row)
                    let idString = self.model.fileList[row].id
                    let photo:JSON = ["id": idString ?? "" ,"url": ""]
                    self.uploadPhotoArray.append(photo)
                    self.model.fileList.remove(at: row)
                    self.tableView.reloadData()
                    
                    
                }
                // 添加
                cell.uploadPhotoBlock = {[weak self] in
                    print("添加")
                    guard let sSelf = self else {return}
                    
                    sSelf.albumManager.startAlbumAction(isCamera: false) { (resultImage) in
                        guard let image = resultImage else {
                            return
                        }
                        let data: Data = UIImageJPEGRepresentation(image, 0.5)!
                        let imageName = String(describing: NSDate()) + ".jpg"
                        print("\(data)-----------------")
                        let param = ["name":imageName,"refRelationCategory":"OTHER_IMAGE_LOCATIONT"]
                        ServerProvider<AccountServer>().upLoadImageRequest(urlString: "\(ZZHelper().uploadURL)/file/phoneUpload", params: param, data: data, fileName: imageName, success: { (response) in
                            let photoUrl = JSON(response)["resultObject"]["filePath"].stringValue
                            let heardString = (photoUrl as NSString).components(separatedBy: "/").last
                            let finalHeader = (heardString! as NSString).components(separatedBy: ".").first
                            let finalString = (photoUrl as NSString).substring(to: (photoUrl.characters.count - (heardString?.characters.count)!))
                            print(photoUrl)
                            let newJson: JSON = ["fileExtension":"jpg","name":finalHeader ?? "", "relativePath":finalString]
                            let newData = FileListModel(json: newJson)
                            print(newJson)
                            let fileJson: JSON = ["id":"" as AnyObject,"url":photoUrl as AnyObject]
                            print("=============")
                            print(fileJson)
                            switch self!.editType {
                                // 新增
                            case .Add:
                                self?.uploadPhotoArray.append(fileJson)
                                self?.addPhotoArray.append(newData)
                                // 修改
                            case .Modify:
                                self?.uploadPhotoArray.append(fileJson)
                                self?.model.fileList.append(newData)

                            }
                            self?.tableView.reloadData()
 
                            
                        }, failture: { (error) in
                            print("\(error)---------")
                            
                        })
                    }

                }
                        
                return cell
            }
            if indexPath.section == 2 {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
     
            var arrayCount:Int = 0
            switch editType {
            case .Add:
                arrayCount = addPhotoArray.count
            case .Modify:
                arrayCount = model.fileList.count
            }
            if arrayCount == 0 {
                return 30 + (ZZScreenWidth - 70) / 5.0
            }
            let width = (ZZScreenWidth - 70) / 5.0
            let zhengCount: Int = arrayCount / 5
            let yuCount: Int = arrayCount % 5
            if yuCount == 0 {
                let firstResult: CGFloat = CGFloat(zhengCount) * width
                return firstResult + CGFloat(zhengCount - 1) * 10.0 + 40.0
            }
            let a: CGFloat = CGFloat(zhengCount) * width + width
            let b: CGFloat = CGFloat(zhengCount - 1) * 10.0
            return a + 40 + b

        default:
            return 60
        }
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
    
    // ????????????
    func returnRemindTextCount(count: Int, text: String, tag: Int) {
        
//            print(count)
//            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! LogAddTableViewCell
//            cell.textNumber.text = "\(count)/1500"
    
        switch tag {
        case 0:
            descript = text
        case 1:
            practice = text
        default:
            standards = text
        }
        
        

    }
        
}


