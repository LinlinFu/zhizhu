//
//  PrepareDetailViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit
enum PageType: String {
    
    case MOBILIZE = "MOBILIZE"//实习动员
    case EDUCATION = "EDUCATION" //安全教育
    case COMMITMENT = "COMMITMENT" //实习承诺
}
enum VideoType: String {
    //实习动员
    case PRACTICE_MOBILIZE_VIDEO = "PRACTICE_MOBILIZE_VIDEO"
    //安全教育
    case PRACTICE_EDUCATION_VIDEO = "PRACTICE_EDUCATION_VIDEO"
    //实习承诺
    case PRACTICE_COMMITMENT_VIDEO = "PRACTICE_COMMITMENT_VIDEO"
}
class PrepareDetailViewController: BaseViewController {
    
    var scrollView: UIScrollView!
    var player: ZGLVideoPlyer!
    var headerTitle: UILabel!
    var headerText = ""
    var webView: UIWebView!
    // 页面类型
    var pageType: PageType = .MOBILIZE
    // 视频类型
    var videoType = ""
    //视频地址
    var videoUrl: String = ""
    //视频占位图片地址
    var videoImgUrl: String = ""
    // html路径
    var htmlPath = ""
    // webView高度
    var webHeight: CGFloat = 300
    // 定时器 约定页面停留时间
    var timer: Timer!
    // 是否是当前计划的所有页面
    var isCurrentPlan = true
    // 计划ID
    var planId = ""
    //
    var nextStageButton: UIButton!
    
    // 下一个的阶段
    var nextType = ""
    
    
    
    // 验证码倒计时
    var remindSeconds: Int = 0 {
        willSet {
            if newValue <= 0 {
                isCounting = false
                switch pageType {
                case .EDUCATION:
                    nextStageButton.setTitle("确认提交信息", for: .normal)
                default:
                    nextStageButton.setTitle("进入下一阶段", for: .normal)
                    
                }
            } else {
                nextStageButton.setTitle("\(newValue)s后可进入下一步", for: .disabled)
                
            }
        }
    }
    // 是否在计算时间
    var isCounting: Bool = false {
        willSet {
            if newValue {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                remindSeconds = 59
                nextStageButton.isEnabled = false
                nextStageButton.backgroundColor = ZZLightGrayBg
            } else {
                timer.invalidate()
                timer = nil
                nextStageButton.isEnabled = true
                nextStageButton.backgroundColor = ZZMainGreen
                
            }
        }
    }
    
    // 点击下一步
    func nextStageAction() {
        print("进入下一步")
        
        switch pageType {
        case .MOBILIZE:
            nextType = "STAGE12_EDUCATION"
            gointoNextStage(finalType: nextType)
        case .COMMITMENT:
            nextType = "STAGE14_REGISTRATION"
            gointoNextStage(finalType: nextType)
        case .EDUCATION:
            let alertV = YHAlertView(title: "提交成功", message: "您将参加考试以检验对安全知识的掌握程度! 总共50题,满分100分,10分以上合格!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: ["确定"])
            alertV.visual = false
            alertV.show()
            
            
        default:
            break
        }
        
    }
    
    // 改变当前的Stage
    func gointoNextStage(finalType: String) {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .gotoNextStage(stage: finalType)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: .failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                let vc = PrepareDetailViewController()
                switch self.pageType {
                case .MOBILIZE:
                    vc.pageType = .EDUCATION
                case .COMMITMENT:
                    let vc = PracticeRegisterViewController()
                    vc.canEdit = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                default:
                    return
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: .failure)
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func timerAction() {
        remindSeconds -= 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isCurrentPlan {
            buildNextStageButton()
        }
        videoType = "PRACTICE_\(pageType.rawValue)_VIDEO"
        if videoType == "PRACTICE_EDUCATION_VIDEO" {
            // 安全教育 请求成功 结果为空
            searchEducationVideoPath()
        } else {
            searchVideoPath()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        if nextStageButton != nil {
            nextStageButton.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //AMRK: 下一步按钮
    func buildNextStageButton() {
        nextStageButton = UIButton(frame: CGRect(x: 0, y: ZZScreenHeight - 50, width: ZZScreenWidth, height: 50))
        nextStageButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        nextStageButton.addTarget(self, action: #selector(nextStageAction), for: .touchUpInside)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(nextStageButton)
        
        
        
    }
    
    func searchVideoPath() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .serchVideoPath(type: videoType)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                if self.isCurrentPlan {
                    // 倒计时开始
                    self.isCounting = true
                }
                if JSON(info)["resultObject"] != nil {
                    let relativePath = JSON(info)["resultObject"]["relativePath"].stringValue
                    let name = JSON(info)["resultObject"]["name"].stringValue
                    self.videoUrl = "http://upload.zz-w.cn" + relativePath + name + ".mp4"
                    self.videoImgUrl = "http://upload.zz-w.cn" + relativePath + name + "/1_1.jpg"
                    print(self.videoUrl)
                    print(self.videoImgUrl)
                } else {
                    self.videoUrl = "http://vjs.zencdn.net/v/oceans.mp4"
                    self.videoImgUrl = "http://upload.zz-w.cn/upload/video/exercitation/2016093015/o1b02ijpaac57kma1dio2rh1ji57/1_1.jpg"
                }
                self.setupUI()
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }
    
    // 安全教育视频
    func searchEducationVideoPath() {
        if isCurrentPlan {
            planId = AppKeys.getPlanId()
        }
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getSafeEducation(planId: planId)) { (success, info) in
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            let status = JSON(info)["status"].intValue
            if success && status == 200 {
                if self.isCurrentPlan {
                    // 倒计时开始
                    self.isCounting = true
                }
                if JSON(info)["resultObject"] != nil {
                    let relativePath = JSON(info)["resultObject"]["relativePath"].stringValue
                    let name = JSON(info)["resultObject"]["name"].stringValue
                    self.videoUrl = "http://upload.zz-w.cn" + relativePath + name + ".mp4"
                    self.videoImgUrl = "http://upload.zz-w.cn" + relativePath + name + "/1_1.jpg"
                    print(self.videoUrl)
                    print(self.videoImgUrl)
                } else {
                    self.videoUrl = "http://vjs.zencdn.net/v/oceans.mp4"
                    self.videoImgUrl = "http://upload.zz-w.cn/upload/video/exercitation/2016093015/o1b02ijpaac57kma1dio2rh1ji57/1_1.jpg"
                }
                self.setupUI()
                
            } else {
                let vc = RemindViewController(title: JSON(info)["errorMessage"].stringValue, type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
        }
        
    }
    
    func setupUI() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: ZZScreenHeight - 64))
        scrollView.backgroundColor = ZZWhiteBackground
        scrollView.contentSize = CGSize(width: ZZScreenWidth, height: webHeight + 230)
        view.addSubview(scrollView)
        
        
        switch pageType {
        case .MOBILIZE: // 动员
            print(videoUrl)
            htmlPath = Bundle.main.path(forResource: "mobilize", ofType: "html")!
            self.title = "实习动员"
            headerText = "    实习动员书"
        case .EDUCATION: // 教育
            htmlPath = Bundle.main.path(forResource: "education", ofType: "html")!
            self.title = "安全教育"
            headerText = "    顶岗实习安全教育"
        case .COMMITMENT: // 承诺
            htmlPath = Bundle.main.path(forResource: "promise", ofType: "html")!
            self.title = "实习承诺"
            headerText = "    实习行为承诺书"
        }
        self.player = ZGLVideoPlyer(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth, height: 200))
        //        self.networkJudgement()
        player.videoImgUrl = videoImgUrl
        //        player.loadVideo = {[weak self]() -> Void in
        //            self?.player.videoUrlStr = self?.videoUrl
        //        }
        player.videoUrlStr = videoUrl
        scrollView.addSubview(player)
        
        headerTitle = UILabel(frame: CGRect(x: 0, y: 200, width: ZZScreenWidth, height: 30))
        headerTitle.font = UIFont.systemFont(ofSize: 16)
        headerTitle.text = headerText
        headerTitle.backgroundColor = ZZMainLineGray
        scrollView.addSubview(headerTitle)
        
        webView = UIWebView(frame: CGRect(x: 0, y: 230, width: ZZScreenWidth, height: webHeight))
        webView.delegate = self
        webView.scrollView.bounces = false
        do {
            let htmlString =  try String.init(contentsOfFile: htmlPath, encoding: String.Encoding.utf8)
            webView.loadHTMLString(htmlString, baseURL: URL(string: htmlPath))
        } catch {
            
        }
        scrollView.addSubview(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: 网络判断?????????
    func networkJudgement() {
        let reach = Reachability(hostname: "www.baidu.com")
        
        reach?.reachableBlock = {(reachability) in
            DispatchQueue.main.async(execute: {
                if (reachability?.isReachableViaWiFi())! {
                    print("当前使用WiFi网络")
                    let alertVC = UIAlertController(title: "温馨提示", message: "当前使用环境是流量, 土豪请继续", preferredStyle: .alert)
                    let sureAction = UIAlertAction(title: "继续", style: .default, handler: { ( action
                        ) in
                    })
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {( action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alertVC.addAction(cancelAction)
                    alertVC.addAction(sureAction)
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else if (reachability?.isReachableViaWWAN())! {
                    print("当前使用3G网络")
                    
                    
                }
            })
            
        }
        
        reach?.unreachableBlock = {(reachability) in
            DispatchQueue.main.async(execute: {
                if (reachability?.isReachableViaWiFi())! {
                    print("没有网络连接")
                    
                }
                
            })
        }
        reach?.startNotifier()
    }
    
    
    deinit{
        
    }
    
}

extension PrepareDetailViewController: UIWebViewDelegate, YHAlertViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //HTML5的高度
        let htmlHeight = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight")
        //HTML5的宽度
        let htmlWidth = webView.stringByEvaluatingJavaScript(from: "document.body.scrollWidth")
        //宽高比
        let scale: CGFloat = CGFloat((htmlWidth! as NSString).floatValue / (htmlHeight! as NSString).floatValue)
        //webview控件的最终高度
        webHeight = ZZScreenWidth / scale
        scrollView.contentSize = CGSize(width: ZZScreenWidth, height: webHeight + 230)
        webView.frame = CGRect(x: 0, y: 230, width: ZZScreenWidth, height: webHeight + 0.1)
        
        print(scrollView.contentSize)
        print(webView.frame)
        
    }
    
    
    func alertView(alertView: YHAlertView, clickedButtonAtIndex: Int) {
        print("点击下标是:\(clickedButtonAtIndex)")
        let examVC = ExaminationViewController()
        examVC.title = AppKeys.getPlanName()
        self.navigationController?.pushViewController(examVC, animated: true)
    }
}
