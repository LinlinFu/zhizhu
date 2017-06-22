//
//  MineTableViewHeader.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/18.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit


class MineTableViewHeader: UIView {

    // 底层View
    var backView: UIView!
    // 背景图片
    var backImageView: UIImageView!
    // 中层view
    var middleView: UIView!
    // 头像 
    var userImageView: UIImageView!
    // 姓名
    var userName: UILabel!
    var viewFrame: CGRect!
    
    // 设置头像的回调
    var tapAvatarHandle: ((UIImageView) -> ())? = nil
    
    override init(frame: CGRect) {
        viewFrame = frame
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupUI() {
        backView = UIView()
        addSubview(backView)
        backImageView = UIImageView()
        middleView = UIView()
        userName = UILabel()
        userImageView = UIImageView()
        [backImageView, middleView].forEach { (subview) in
            backView.addSubview(subview)
        }
        [userImageView, userName].forEach { (subview) in
            middleView.addSubview(subview)
        }
        
        var path = ""
        let isDev = ZZHelper.isDevEvironment()
        if isDev {
            path = "http://172.16.1.250:94"
        } else {
            path = "http://upload.zz-w.cn"
        }
        userImageView.kf_setImageWithURL(URL: URL(string: path + AppKeys.getUserphotoUrl()), placeholderImage: UIImage(named: "userImage"))
        userImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapUserImageAction(tap:)))
        userImageView.addGestureRecognizer(tap)
        backImageView.image = UIImage(named: "backImage")
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 30
        userName.font = UIFont.systemFont(ofSize: 16)
        userName.textColor = ZZWhiteBackground
        userName.text = AppKeys.getUserRealName()
        userName.textAlignment = .center
        
    }
    
    // 换头像
    func tapUserImageAction(tap: UITapGestureRecognizer) {
        if tapAvatarHandle != nil {
            tapAvatarHandle!(tap.view! as! UIImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(self)
            
        }
        
       
        backImageView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
        
        middleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(backView.snp.centerX)
            make.centerY.equalTo(backView.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(80)
        }
        
        userImageView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(middleView)
            make.height.equalTo(60)
            
        }
        
        
        userName.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(middleView)
            make.top.equalTo(userImageView.snp.bottom).offset(5)
        }
        
        
        
        
        
    }
}
