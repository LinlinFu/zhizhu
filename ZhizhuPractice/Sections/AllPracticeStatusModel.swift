//
//  AllPracticeStatusModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AllPracticeStatusModel: NSObject {

//    "status": 200,
//    "errorMessage": null,
//    "resultObject": {
//    "dayCount": 2,
//    "count": 2,
//    "missionLast": 212,
//    "plan": {
//    "id": "149482893428792725",
//    "planName": "2017new测试计划",
//    "examinationId": "148350900727970108",
//    "passMark": 10,
//    "endTime": 1514649600000,
//    "createTime": null,
//    "dailyNumber": 10,
//    "weekNumber": 10,
//    "schoolId": "8",
//    "type": "PRE_TIME",
//    "planType": null,
//    "startTime": null,
//    "preTimeS": null,
//    "preTimeE": null,
//    "conductTimeS": null,
//    "conductTimeE": null,
//    "reportTimeS": null,
//    "reportTimeE": null,
//    "assessTimeS": null,
//    "assessTimeE": null,
//    "summaryTimeS": null,
//    "summaryTimeE": null,
//    "classMsg": null,
//    "signWeight": null,
//    "dailyWeight": null,
//    "weekWeight": null,
//    "taskWeight": null,
//    "reportWeight": null,
//    "summaryWeight": null,
//    "pleaWeight": null,
//    "procedureType": null,
//    "planId": null,
//    "startTimeP": null,
//    "endTimeP": null,
//    "classCount": null,
//    "startToEndTime": null,
//    "paperName": null,
//    "procedureId": null,
//    "weightId": null,
//    "weight": null,
//    "typeName": null,
//    "today": null
//    },
//    "weekCount": 2,
//    "isSign": true
//    }

    
    
    
    //写的日志个数
    var dayCount: Int!
    //写的周记个数
    var weekCount: Int!
    //实习任务剩余天数
    var missionLast: Int!

    // plan model
    var plan: Plan!
    
    init(json:JSON) {
        dayCount = json["dayCount"].intValue
        weekCount = json["weekCount"].intValue
        missionLast = json["missionLast"].intValue
        plan = Plan(json: json["plan"])
    }
    
   
}

struct Plan {
    //计划Id
    var id: String!
    // 日志总数
    var dailyNumber: Int!
    // 周记总数:
    var weekNumber: Int!
    
    
    init(json:JSON) {
        id = json["id"].stringValue
        dailyNumber = json["dailyNumber"].intValue
        weekNumber = json["weekNumber"].intValue
    }
    
    

}
