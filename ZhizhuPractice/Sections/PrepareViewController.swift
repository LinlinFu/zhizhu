//
//  PrepareViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/17.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
enum StageType: String {
    // 实习动员
    case STAGE11_MOBILIZATION = "STAGE11_MOBILIZATION"
    // 安全教育
    case STAGE12_EDUCATION = "STAGE12_EDUCATION"
    // 实习承诺
    case STAGE13_COMMITMENT = "STAGE13_COMMITMENT"
    // 实习计划登记
    case STAGE14_REGISTRATION = "STAGE14_REGISTRATION"
    // 实习报到
    case STAGE15_REPORT = "STAGE15_REPORT"
    // 工地反馈
    case STAGE16_FEEDBACK = "STAGE16_FEEDBACK"
    // 实习报告
    case STAGE20_SECOND = "STAGE20_SECOND"
}
class PrepareViewController: BaseViewController {
    
    // 背景图片
    var backgroundImage: UIImageView!
    
    //纵向间距
    let yMargin: CGFloat = (ZZScreenHeight - 64 - 49) / 7.0
    // 横向间距
    let xMargin: CGFloat = ZZScreenWidth / 4.0
    // view高度
    let viewHeight: CGFloat = 40
    
    // "工地情况反馈"
    var oneView: PrepareLevelView!
    // "实习报道"
    var twoView: PrepareLevelView!
    // "实习计划登记"
    var threeView: PrepareLevelView!
    // "实习承诺"
    var fourView: PrepareLevelView!
    // "安全教育"
    var fiveView: PrepareLevelView!
    // "安全动员"
    var sixView: PrepareLevelView!
    
    // 当前阶段
    var currentStage: StageType = .STAGE20_SECOND
    
    //未读红点
    var unReadImage: UIView!
    var unReadButton: UIButton!
    var unReadView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNoReadCount()
        setupUI()
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        oneView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "notice"), style: .plain, target: self, action: #selector(noticeAction))
        unReadView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        unReadButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        unReadView.addSubview(unReadButton)
        unReadButton.setImage(UIImage(named: "notice"), for: .normal)
        unReadButton.addTarget(self, action: #selector(noticeAction), for: .touchUpInside)
        unReadImage = UIView(frame: CGRect(x: 20, y: 5, width: 7, height: 7))
        unReadView.addSubview(unReadImage)
        unReadImage.backgroundColor = UIColor.red
        unReadImage.layer.cornerRadius = 3.5
        unReadImage.layer.masksToBounds = true
        unReadImage.isHidden = true
        self.navigationItem.rightBarButtonItem?.customView = unReadView
        
        
        
    }
    
    //MARK: 查看通知
    func noticeAction() {
        let vc = NoticeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        
        backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64 - 49))
//        backgroundImage.image = UIImage(named: "prepare_bg")
        view.addSubview(backgroundImage)
        
        oneView = PrepareLevelView(frame: CGRect(x: 2 * xMargin - viewHeight / 2.0, y: yMargin - viewHeight / 2.0, width: 115.0, height: viewHeight), btuName: "ic_main_report_normal", titleName: "上传附件", direction: .Right, tag: 6)
        twoView = PrepareLevelView(frame: CGRect(x: xMargin - viewHeight / 2.0, y: 2 * yMargin - viewHeight / 2.0, width: 140.0, height: viewHeight), btuName: "ic_main_tickling_normal", titleName: "工地情况反馈", direction: .Right, tag: 5)
        threeView = PrepareLevelView(frame: CGRect(x: 2 * xMargin - viewHeight / 2.0, y: 3 * yMargin - viewHeight / 2.0, width: 140.0, height: viewHeight), btuName: "ic_main_plan_normal", titleName: "实习计划登记", direction: .Right, tag: 4)
        fourView = PrepareLevelView(frame: CGRect(x: 2 * xMargin - viewHeight / 2.0 + 5, y: 4 * yMargin - viewHeight / 2.0, width: 115.0, height: viewHeight), btuName: "ic_main_promise_normal", titleName: "实习承诺", direction: .Left, tag: 3)
        fiveView = PrepareLevelView(frame: CGRect(x: 2 * xMargin - viewHeight / 2.0, y: 5 * yMargin - viewHeight / 2.0, width: 115.0, height: viewHeight), btuName: "ic_main_education_proceed", titleName: "安全教育", direction: .Right, tag: 2)
        sixView = PrepareLevelView(frame: CGRect(x: xMargin - viewHeight / 2.0, y: 6 * yMargin - viewHeight / 2.0, width: 115.0, height: viewHeight), btuName: "ic_main_mobilize_finish", titleName: "安全动员", direction: .Right, tag: 1)
        [oneView, twoView, threeView, fourView, fiveView, sixView].forEach { (subview) in
            view.addSubview(subview)
        }
        oneView.middleButton.addTarget(self, action: #selector(siteStatusFeedback(button:)), for: .touchUpInside)
        twoView.middleButton.addTarget(self, action: #selector(practiceReport(button:)), for: .touchUpInside)
        threeView.middleButton.addTarget(self, action: #selector(practicePlan(button:)), for: .touchUpInside)
        fourView.middleButton.addTarget(self, action: #selector(practicePromise(button:)), for: .touchUpInside)
        fiveView.middleButton.addTarget(self, action: #selector(saftyEducation(button:)), for: .touchUpInside)
        sixView.middleButton.addTarget(self, action: #selector(saftyMobilize(button:)), for: .touchUpInside)
        
        
        
    }
    
    // MARK: 获取未读消息数量
    func getNoReadCount() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getUserNoReadMsgCount) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                let count = JSON(info)["resultObject"]["count"].intValue
                if count == 0 {
                    self.unReadImage.isHidden = true
                } else {
                    self.unReadImage.isHidden = false
                }
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }
    
    //AMRK: 获取当前阶段
    func fetchData() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getCurrentStage) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                
                let resultObject = JSON(info)["resultObject"].string
                if resultObject != nil {
                    self.sureViewStage(type: StageType(rawValue: resultObject!)!)
                } else {
                    
                    self.sureViewStage(type: StageType(rawValue: "STAGE11_MOBILIZATION")!)
                }
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }
    //MARK: 确定页面状态
    func sureViewStage(type: StageType) {
        
        for btnView in view.subviews {
            if (btnView.isKind(of: PrepareLevelView.self)) {
                let btn: PrepareLevelView = btnView as! PrepareLevelView
                switch type {
                //实习结束
                case .STAGE20_SECOND:
                    btn.middleButton.isEnabled = false
                    btn.middleButton.setImage(UIImage(named: "stage_\(btn.middleButton.tag)_finish"), for: .disabled)
                    self.backgroundImage.image = UIImage(named: "prepare_bg")
                //安全动员
                case .STAGE11_MOBILIZATION:
                    setButtonStage(btn: btn, tag: 1)
                // 安全教育
                case .STAGE12_EDUCATION:
                    setButtonStage(btn: btn, tag: 2)
                // 实习承诺
                case .STAGE13_COMMITMENT:
                    setButtonStage(btn: btn, tag: 3)
                // 实习计划登记
                case .STAGE14_REGISTRATION:
                    setButtonStage(btn: btn, tag: 4)
                // 工地情况反馈
                case .STAGE16_FEEDBACK:
                    setButtonStage(btn: btn, tag: 5)
                // 实习报道(改为了上传附件)
                case .STAGE15_REPORT:
                    setButtonStage(btn: btn, tag: 6)
                    
                default:
                    break
                }
                
            }
        }
        
        
    }
    
    
    func setButtonStage(btn: PrepareLevelView, tag: Int) {
        if btn.middleButton.tag != tag {
            btn.middleButton.isEnabled = false
            if btn.middleButton.tag < tag {
                btn.middleButton.setImage(UIImage(named: "stage_\(btn.middleButton.tag)_finish"), for: .disabled)
            } else {
                btn.middleButton.setImage(UIImage(named: "stage_\(btn.middleButton.tag)_normal"), for: .disabled)
            }
        }
        btn.middleButton.setImage(UIImage(named: "stage_\(btn.middleButton.tag)_proceed"), for: .normal)
        btn.middleButton.setImage(UIImage(named: "stage_\(btn.middleButton.tag)_proceed"), for: .selected)
        self.backgroundImage.image = UIImage(named: "prepare_bg")
        
    }
    
    //MARK: 按钮点击方法
    // 上传附件
    func siteStatusFeedback(button: UIButton) {
        
        let vc = UploadFilesViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 工地情况反馈
    func practiceReport(button: UIButton) {
        //        let vc = PraticeReportViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
        let vc = TestFeedbackViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // 实习计划登记
    func practicePlan(button: UIButton) {
        let vc = PracticeRegisterViewController()
        vc.canEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // 实习承诺
    func practicePromise(button: UIButton) {
        let vc = PrepareDetailViewController()
        vc.pageType = .COMMITMENT
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // 安全教育
    func saftyEducation(button: UIButton) {
        let vc = PrepareDetailViewController()
        vc.pageType = .EDUCATION
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    // 安全动员
    func saftyMobilize(button: UIButton) {
        let vc = PrepareDetailViewController()
        vc.pageType = .MOBILIZE
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}
