//
//  ReportModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class ReportModel: NSObject {
//    "id": "148386554240141307",
//    "exercitationPlanId": "148099410377169360",
//    "createUserId": "148099376859633424",
//    "reportTime": 1483804800000,
//    "workingStartTime": "08:00",
//    "workingEndTime": "17:00",
//    "workingContent": "策略",
//    "companyRules": "无",
//    "workingHelp": "无",
//    "createTime": null,
//    "status": 1,
//    "auditTime": null,
//    "name": null,
//    "className": null,
//    "theName": null,
//    "auditRecordList": [
//    {
//    "id": "148391508944813149",
//    "refTable": "COMPANY_REPORT",
//    "refTableId": "148386554240141307",
//    "auditUserId": "148099322967320542",
//    "auditTime": 1483915089000,
//    "status": 1,
//    "comment": ""
//    }
//    ],
//    "classId": null,
//    "upAndUnList": null,
//    "checkStatus": null,
//    "checkTime": null
    
    //到岗时间
    var reportTime: String!
    // 作息时间
    var workingStartTime: String!
    var workingEndTime: String!
    // 工作内容
    var workingContent: String!
    // 公司规定
    var companyRules: String!
    // 疑难救助
    var workingHelp: String!
    // 审核记录
    var auditRecordList: [AuditRecordList] = []
    
    init(json: JSON) {
        reportTime = json["reportTime"].stringValue
        workingStartTime = json["workingStartTime"].stringValue
        workingEndTime = json["workingEndTime"].stringValue
        workingContent = json["workingContent"].stringValue
        companyRules = json["companyRules"].stringValue
        workingHelp = json["workingHelp"].stringValue
        for list in json["auditRecordList"].arrayValue {
            let list = AuditRecordList(json: list)
            auditRecordList.append(list)
        }
    }

}
