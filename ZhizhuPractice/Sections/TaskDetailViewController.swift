//
//  TaskDetailViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
// 任务类型
enum TaskType{
    // 申请
    case Apply
    // 实施
    case Implement
}

class TaskDetailViewController: WMPageController {

    
    var type: TaskType = .Apply
    var topView: UIView!
    var taskName: UILabel!
    var taskTime: UILabel!
    // 上级列表中的id
    var missionDeclareId = ""
    
    // 申报数据
    var applyModel: TaskDetailModel!
    // 实施数据
    var implementModel: TaskImplementDetailModel!
    
    
    override func viewDidLoad() {
        
        self.title = "任务详情"
        buildTopView()
        buildRightItem()
        setupUI()
        switch type {
        case .Apply:
            fetchApplyDetail()
        case .Implement:
            fetchApplyDetail()
            fetchImplementDetail()
        }
        super.viewDidLoad()

        
    }
    
    
    func setupUI() {
        self.viewFrame = CGRect(x: 0, y: 60, width: ZZScreenWidth, height: ZZScreenHeight - 60 - 64)
        self.menuItemWidth = 80; //每个 MenuItem 的宽度
        self.menuBGColor = ZZWhiteBackground
        self.menuViewStyle = .line//这里设置菜单view的样式
        self.progressHeight = 1 //下划线的高度，需要WMMenuViewStyleLine样式
        self.progressColor = ZZMainGreen//设置下划线(或者边框)颜色
        self.titleSizeSelected = 14//设置选中文字大小
        self.titleColorSelected = ZZMainGreen//设置选中文字颜色
        self.titleSizeNormal = 14
        self.selectIndex = 0
        
    }
    
    //AMRK: 顶部信息
    func buildTopView() {
        topView = UIView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 60))
        view.addSubview(topView)
        taskName = UILabel()
        taskName.font = UIFont.systemFont(ofSize: 14)
        topView.addSubview(taskName)
        switch type {
        case .Apply:
            taskName.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.centerY.equalTo(topView.snp.centerY)
            })
        case .Implement:
            taskName.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.top.equalTo(10)
            })
            taskTime = UILabel()
            taskTime.font = UIFont.systemFont(ofSize: 12)
            taskTime.textColor = UIColor.darkGray
            topView.addSubview(taskTime)
            taskTime.snp.makeConstraints({ (make) in
                make.left.equalTo(taskName.snp.left)
                make.top.equalTo(taskName.snp.bottom).offset(5)
            })
            
        }
        let line = UIView(frame: CGRect(x: 0, y: 59, width: ZZScreenWidth, height: 1))
        line.backgroundColor = ZZMainLineGray
        topView.addSubview(line)
        
    }
    
    //AMRK: rightItem
    func buildRightItem() {

        let but = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        but.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        but.setTitleColor(ZZWhiteBackground, for: .normal)
        switch type {
        case .Apply:
            but.setTitle("审核记录", for: .normal)
        case .Implement:
            but.setTitle("教师点评", for: .normal)
        }
        but.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: but)
    
    }
    
    // rightItemAction
    func submitAction() {
        
        switch type {
        case .Apply:
            let vc = AuditRecordViewController()
            vc.missionDeclareId = missionDeclareId
            self.navigationController?.pushViewController(vc, animated: true)
        case .Implement:
            let vc = TeacherMarkViewController()
            vc.implementModel = implementModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    // MARK:任务申报
    func fetchApplyDetail() {
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getMissionDeclareDetails(missionDeclareId: missionDeclareId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                self.applyModel = TaskDetailModel(json: JSON(info)["resultObject"])
                self.taskName.text = self.applyModel.name
                if self.taskTime != nil {
                    self.taskTime.text = "\(ZZHelper.timeFormat(timeStamp: self.applyModel.startTime, format: "yyyy/MM/dd"))-" + "\(ZZHelper.timeFormat(timeStamp: self.applyModel.endTime, format: "yyyy/MM/dd"))"
                }
                
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
    }
    
    // MARK:任务实施
    func fetchImplementDetail() {
        let param: [String: AnyObject] = ["missionDeclareId": missionDeclareId as AnyObject]
        ServerProvider<ReportServer>().requestReturnDictionary(target: .getMissionImplement(param: param)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                self.implementModel = TaskImplementDetailModel(json: JSON(info)["resultObject"])
                                
                
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
    

    //设置viewcontroller的个数
    override func numbersOfChildControllers(in pageController: WMPageController!) -> Int {
        switch type {
        case .Apply:
            return 3
        case .Implement:
            return 4
        }
        
    }
    //设置对应的viewcontroller
    override func pageController(_ pageController: WMPageController!, viewControllerAt index: Int) -> UIViewController! {
        switch type {
        case .Apply:
            switch index {
            case 0:
                let subApply = TaskSubApplyViewController()
                subApply.dataModel = applyModel
                return subApply
            case 1:
                let subDescript = TaskSubDescriptViewController()
                subDescript.dataModel = applyModel
                return subDescript
            case 2:
                let subFile = TaskSubFileViewController()
                subFile.dataModel = applyModel
                return subFile
            default:
                return UIViewController()
            }
        case .Implement:
            switch index {
            case 0:
                let subImplement = TaskSubImplementViewController()
                subImplement.dataModel = implementModel
                return subImplement
            case 1:
                let subApply = TaskSubApplyViewController()
                subApply.dataModel = applyModel
                return subApply
            case 2:
                let subDescript = TaskSubDescriptViewController()
                subDescript.dataModel = applyModel
                return subDescript
            case 3:
                let subFile = TaskSubFileViewController()
                subFile.dataModel = applyModel
                return subFile
            default:
                return UIViewController()            }

        }
        
    }
    //设置每个viewcontroller的标题
    override func pageController(_ pageController: WMPageController!, titleAt index: Int) -> String! {
        switch type {
        case .Apply:
            return ["任务申报", "任务描述", "任务附件"][index]
        case .Implement:
            return ["任务实施", "任务申报", "任务描述", "任务附件"][index]

        }
    }



}
