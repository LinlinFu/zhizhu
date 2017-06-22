//
//  LogWeekModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/1.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class LogWeekModel: NSObject {
    //    "practice": null,
    //    "standards": null,
    //    "weatherMorn": null,
    //    "weatherAfter": null,
    //    "temperature": null,
    //    "id": "149625223682754917",
    //    "exercitationPlanId": null,
    //    "type": null,
    //    "description": "今天继续下污水管道，要注意留出通化粪池的管道，",
    //    "sort": 117,
    //    "createTime": 1496252236000,
    //    "updateTime": null,
    //    "score": null,
    //    "remarks": null,
    //    "markUserId": null,
    //    "markTime": null,
    //    "createTimeString": null,
    //    "createUserId": null,
    //    "name": "李响",
    //    "dailyNumber": 150,
    //    "weekNumber": 21,
    //    "readCount": 88,
    //    "className": null,
    //    "theName": null,
    //    "upPieceId": null,
    //    "unPieceId": null,
    //    "fileList": null,
    //    "logList": null,
    //    "files": null
    
    //日记/周记id
    var id: String!
    // 日记描述
    var descript: String!
    // 排序数字
    var sort: Int!
    // 创建时间
    var createTime: String!
    // 创建人名字
    var name: String!
    // 日记总数
    var dailyNumber: Int!
    // 周记总数
    var weekNumber: Int!
    // 已读数?
    var readCount: Int!
    // 评语
    var remarks: String!
    
    init(json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        descript = json["description"].stringValue
        createTime = json["createTime"].stringValue
        sort = json["sort"].intValue
        dailyNumber = json["dailyNumber"].intValue
        weekNumber = json["weekNumber"].intValue
        readCount = json["readCount"].intValue
        remarks = json["remarks"].stringValue

        
    }

}
