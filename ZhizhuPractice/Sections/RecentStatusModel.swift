//
//  RecentStatusModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/1.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class RecentStatusModel: NSObject {
//    "id": "149590821591285430",
//    "createUserId": "148099376859633424",
//    "createTime": "2017-05-28 02:03:35",
//    "description": "新增日报",
//    "refTable": "S_DAILYREPORT",
//    "refTableId": "149590821591240260"
    
    
    //记录id
    var id: String!
    // 创建人id
    var createUserId: String!
    // 状态内容
    var descript: String!
    // 创建时间
    var createTime: String!
    // 创建人名字
    var refTable: String!
    // 日记总数
    var refTableId: String!

    
    init(json: JSON) {
        id = json["id"].stringValue
        createUserId = json["createUserId"].stringValue
        descript = json["description"].stringValue
        createTime = json["createTime"].stringValue
        refTable = json["refTable"].stringValue
        refTableId = json["refTableId"].stringValue
    }

}
