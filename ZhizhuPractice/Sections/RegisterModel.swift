//
//  RegisterModel.swift
//  ZhizhuPractice
//
//  Created by wujianlin on 2017/6/5.
//  Copyright © 2017年 wujianlin. All rights reserved.
//

import UIKit

class RegisterModel: NSObject {

//    "id": "148383554119222705",
//    "exercitationPlanId": "148099410377169360",
//    "createUserId": "148099376859633424",
//    "startTime": 1483977600000,
//    "endTime": 1498838400000,
//    "company": "滕州市颐佳科技有限公司",
//    "area": "山东-枣庄-滕州市",
//    "address": "山东省枣庄市滕州市新兴中路160-4号",
//    "latitude": "0,0",
//    "createTime": null,
//    "status": 1,
//    "auditTime": null,
//    "name": null,
//    "className": null,
//    "theName": null,
//    "auditRecordList": [
//    {
//    "id": "148384123617125647",
//    "refTable": "COMPANY_REGISTER",
//    "refTableId": "148383554119222705",
//    "auditUserId": "148099322967320542",
//    "auditTime": 1483841236000,
//    "status": 1,
//    "comment": ""
//    }
//    ],
//    "classId": null,
//    "upAndUnList": null,
//    "checkStatus": null,
//    "checkTime": null
    
    var id: String!
    var startTime: String!
    var endTime: String!
    var company: String!
    var area: String!
    var address: String!
    // 审核结果 1代表通过
    var auditRecordList: [AuditRecordList] = []
    var status: Int!
    
    init(json: JSON) {
        id = json["id"].stringValue
        startTime = json["startTime"].stringValue
        endTime = json["endTime"].stringValue
        company = json["company"].stringValue
        area = json["area"].stringValue
        address = json["address"].stringValue
        status = json["status"].intValue
        for list in json["auditRecordList"].arrayValue {
            let list = AuditRecordList(json: list)
            auditRecordList.append(list)
        }

    }
    

}

// 审核记录列表
struct AuditRecordList {
    //    "id": "148384123617125647",
    //    "refTable": "COMPANY_REGISTER",
    //    "refTableId": "148383554119222705",
    //    "auditUserId": "148099322967320542",
    //    "auditTime": 1483841236000,
    //    "status": 1,
    //    "comment": ""
    
    var id: String!
    var refTable: String!
    var refTableId: String!
    var auditUserId: String!
    var auditTime: String!
    var status: Int!
    var comment: String!
    
    init(json: JSON) {
        id = json["id"].stringValue
        refTable = json["refTable"].stringValue
        refTableId = json["refTableId"].stringValue
        auditUserId = json["auditUserId"].stringValue
        auditTime = json["auditTime"].stringValue
        comment = json["comment"].stringValue
        status = json["status"].intValue
    }
}











