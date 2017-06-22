//
//  AppConfig.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/5/16.
//  Copyright © 2017年 wujianlin. All rights reserved.
//


/*
 *
 *   此文件夹下定义了项目中常用的宏
 *   此文件若有新增属性，必须以ZZ开头
 *
 */


import Foundation

//MARK: 第三方
import SnapKit
import Kingfisher

//MARK: 全局常用属性
public let ZZNavigationHeight: CGFloat = 64
public let ZZScreenBounds: CGRect = UIScreen.main.bounds
public let ZZScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let ZZScreenHeight: CGFloat = UIScreen.main.bounds.size.height

//MARK: APPkey- 第三方key配置
public let ZZAMapKey = "7577a0435c4796f01e6a32cdf88c2e2a" // 高德



//MARK: 服务器
public let ZZDevIP = "http://172.16.1.250:88"  // 本地 http:172.16.1.253:8080
public let ZZDisIP = "http://mobile.sx.zz-w.cn"
public let ZZDevUpload = "http://172.16.1.250:94" //上传
public let ZZDisUpload = "http://upload.zz-w.cn"

//MARK: 常用颜色
public let ZZWhiteBackground = UIColor.white
public let ZZRed = UIColor(hexString: "#F0182C")
public let ZZBlack = UIColor.black


// 主题绿色
public let ZZMainGreen = UIColor(hex: 0x86B524)
// 分割线浅灰色
public let ZZMainLineGray = UIColor(hexString: "#F3F3F3")
// 灰色字体
public let ZZGray = UIColor(hex: 0x9C9C9C)
// 浅灰背景
public let ZZLightGrayBg = UIColor(hex: 0xCCCCCC)
public let ZZLightGrayBg_F7F7F7 = UIColor(hex: 0xF7F7F7)
// 橙色字体
public let ZZOrangeText = UIColor(hex: 0xFD9E2C)
// 草绿字体
public let ZZDarkGreenText = UIColor(hex: 0x36C07D)
// 浅黄
public let ZZLightYellowBg = UIColor(hex: 0xFEE793)

extension UIImageView {
    
    func  kf_setImageWithURL(URL: URL?, placeholderImage: Image?, optionsInfo: KingfisherOptionsInfo? = nil, progressBlock: DownloadProgressBlock? = nil, completionHandler: CompletionHandler? = nil) {
        self.kf.setImage(with: ImageResource(downloadURL: URL!), placeholder: placeholderImage, options: optionsInfo, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}





