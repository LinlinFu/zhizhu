//
//  PlistManger.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/15.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit


public enum PlistType: String {
    // 工地情况反馈plist文件
    case FeekbackMaterial = "FeekbackMaterial"
    // 实习登记plist文件
    case RegisterMaterial = "RegisterMaterial"
    
}

class PlistManger: NSObject {
    /**
     根据PlistType查询plist文件
     - parameter plistType:     文件枚举类型
     - returns:                 返回数组，如果不存在返回nil
     */
    internal class func queryPlistFile(plistType: PlistType) -> NSMutableArray? {
        // 获取路径
        let bundle = Bundle.main
        guard let path = bundle
            .path(forResource: plistType.rawValue, ofType: "plist") else {
                return nil
        }
        // 获取数据
        let contents = NSMutableArray(contentsOfFile: path)
        return contents
    }

}
