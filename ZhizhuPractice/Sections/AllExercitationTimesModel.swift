//
//  AllExercitationTimesModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/2.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class AllExercitationTimesModel: NSObject {
//    "summary": {
//    "id": "149482893432486294",
//    "exercitationPlanId": "149482893428792725",
//    "type": "RACTICE_SUMMARY",
//    "startTime": 1514908800000,
//    "endTime": 1514995200000,
//    "status": 1,
//    "summaryType": null,
//    "score": null,
//    "remarks": null
//    },
//    "assess": {
//    "id": "149482893432483131",
//    "exercitationPlanId": "149482893428792725",
//    "type": "ASSESS_TIME",
//    "startTime": 1515168000000,
//    "endTime": 1515254400000,
//    "status": 1,
//    "summaryType": null,
//    "score": null,
//    "remarks": null
//    },
//    "report": {
//    "id": "149482893432477438",
//    "exercitationPlanId": "149482893428792725",
//    "type": "REPORT_TIME",
//    "startTime": 1514736000000,
//    "endTime": 1514822400000,
//    "status": 1,
//    "summaryType": null,
//    "score": null,
//    "remarks": null
//    }
    
    //总结
    var summary: SubTimesModel!
     //考核
    var assess: SubTimesModel!
    //汇报
    var report: SubTimesModel!
    
    init(json:JSON) {
        summary = SubTimesModel(json: json["summary"])
        assess = SubTimesModel(json: json["assess"])
        report = SubTimesModel(json: json["report"])
    }
    
    
    
}

struct SubTimesModel {
    // id
    var id: String!
    // exercitationPlanId
    var exercitationPlanId: String!
    // 类型
    var type: String!
    // 开始时间
    var startTime: String!
    // 结束时间
    var endTime: String!
    // 状态:
    var status: Int!
    
    init(json: JSON) {
        id = json["id"].stringValue
        exercitationPlanId = json["exercitationPlanId"].stringValue
        type = json["type"].stringValue
        startTime = json["startTime"].stringValue
        endTime = json["endTime"].stringValue
        status = json["status"].intValue
    }
    
}








