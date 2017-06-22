//
//  TeacherMarkViewController.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/22.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class TeacherMarkViewController: BaseViewController {

    
    var implementModel: TaskImplementDetailModel!
    var alertView: ZZAlertView!
    var bottomView: UIView!
    var scoreLabel: UILabel!
    var remarks: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "教师点评"
        
        
        if implementModel != nil {
            if implementModel.score != "" {
                setupUI()
            } else {
                buildNoneLogUI()
            }
        }
        
        
    }
    
    func setupUI() {
        bottomView = UIView()
        view.addSubview(bottomView)
        let line = UIView()
        line.backgroundColor = ZZMainLineGray
        bottomView.addSubview(line)
        scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 14)
        bottomView.addSubview(scoreLabel)
        remarks = UILabel()
        remarks.font = UIFont.systemFont(ofSize: 14)
        remarks.numberOfLines = 0
        bottomView.addSubview(remarks)
        
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
        }
        line.snp.makeConstraints { (make) in
            make.left.right.bottom
            .equalTo(0)
            make.height.equalTo(1)
        }
        scoreLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(15)
        }
        remarks.snp.makeConstraints { (make) in
            make.left.equalTo(scoreLabel.snp.left)
            make.top.equalTo(scoreLabel.snp.bottom).offset(10)
            make.right.equalTo(-15)
            make.bottom.equalTo(line.snp.top).offset(-10)
        }
        scoreLabel.text = "评分:\(implementModel.score!)"
        remarks.text = "\(implementModel.remarks)"
        
        
        
    }

    func buildNoneLogUI() {
        alertView = ZZAlertView(frame: CGRect(x: 100, y: 20, width: ZZScreenWidth - 200, height: 0), title: "温馨提示", detailTitle: "暂无教师点评", type: .Simple)
        view.addSubview(alertView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
