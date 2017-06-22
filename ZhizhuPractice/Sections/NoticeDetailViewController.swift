//
//  NoticeDetailViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class NoticeDetailViewController: BaseViewController {

    var idString = ""
    var receiveId = ""
    
    var rightTimeLabel: UILabel!
    var titleLabel: UILabel!
    var detailTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知详情"
        setupUI()
        getNoticeDetail()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: 获取通知详情
    func getNoticeDetail() {
        ServerProvider<PrepareServer>().requestReturnDictionary(target: .getMsgDetail(id: idString, receiveId: receiveId)) { (success, info) in
            
            guard let info = info else {
                let vc = RemindViewController(title: "网络异常", type: RemindType.failure)
                self.present(vc, animated: true, completion: nil)
                return
            }
            if success && JSON(info)["status"].intValue == 200 {
                let msg = JSON(info)["resultObject"]["msg"]
                self.rightTimeLabel.text = ZZHelper.timeFormat(timeStamp: msg["startTime"].stringValue, format: "yyyy-MM-dd")
                self.titleLabel.text = "    " + msg["title"].stringValue
                self.detailTitle.text = msg["content"].stringValue
                self.titleLabel.backgroundColor = ZZMainLineGray
            }
        }
    }
    
    func setupUI() {
        rightTimeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: ZZScreenWidth - 15, height: 40))
        titleLabel = UILabel(frame: CGRect(x: 0, y: 40, width: ZZScreenWidth, height: 40))
        detailTitle = UILabel(frame: CGRect(x: 15, y: 80, width: ZZScreenWidth - 15, height: 50))
        [rightTimeLabel, titleLabel, detailTitle].forEach { (lb) in
            view.addSubview(lb)
        }
        rightTimeLabel.textColor = ZZGray
        rightTimeLabel.textAlignment = .right
        rightTimeLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.backgroundColor = ZZWhiteBackground
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        detailTitle.numberOfLines = 0
        detailTitle.font = UIFont.systemFont(ofSize: 12)
    
    }


}
